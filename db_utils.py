import os
import pandas as pd
import sqlalchemy as db
import mysql.connector

DB_USER = os.environ.get('MYSQL_USER')
DB_PWD = os.environ.get('MYSQL_PWD')
DB_HOST = os.environ.get('MYSQL_HOST')
DB_PORT = os.environ.get('MYSQL_PORT')
DB_SCHEMA = os.environ.get('MYSQL_DB')


def import_equip():
    """
    Reads exported CSV of EQUIP_SUM tab from Blank Concept of Support Model UNCLASSIFIED aka Redonkulator
    and populates equipment table with complete inventory list.
    :return: void
    """
    df = pd.read_csv('redonkulator_app/db/equip.csv')
    df.rename(columns={
        'EQUIP TYPE': 'type',
        'CUBIC FEET': 'cuft',
        'WT (GVW COMBAT LOADED)': 'gvw_combat_loaded',
        'FUEL CAPACITY': 'fuel_capacity',
        'BURN RATE (MPG OR MPH)': 'burn_rate',
        'FUEL PAYLOAD': 'fuel_payload',
        'WATER PAYLOAD': 'water_payload',
        'PALLETS/PALCON': 'pallets_palcons',
        'SIXCON TRANSSPO': 'sixcon_transpo',
        'ISCOCON': 'isocon',
        'COMBAT LOAD PALLET': 'combat_load_pallet',
        'COMBAT LOAD PALLET WEIGHT': 'combat_load_pallet_wt',
        'ASLT RATE PALLET': 'aslt_rate_pallet',
        'ASLT RATE PALLET WEIGHT': 'aslt_rate_pallet_wt',
        'SUSTAIN RATE PALLET': 'sustain_rate_pallet',
        'SUSTAIN RATE PALLET WEIGHT': 'sustain_rate_pallet_wt'
    }, inplace=True)
    df.drop(df.iloc[:, 46:], axis=1, inplace=True)  # drop empty col through TOTAL LCU
    df.drop(df.iloc[:, 39:40], axis=1, inplace=True)  # drop empty col '.'
    df.drop(df.iloc[:, 3:22], axis=1, inplace=True)  # drop AAV BN through LE BATTALION and empty 'w'
    df.dropna(subset=['TAMCN'], inplace=True)  # tamcn is only field requiring non-null.

    engine = db.create_engine(f'mysql+mysqldb://{DB_USER}:{DB_PWD}@{DB_HOST}:{DB_PORT}/{DB_SCHEMA}')
    df.to_sql(name='equipment', con=engine, schema='redonkulator', if_exists='append', index=False)


def import_generic_inventory():
    """
    Reads exported CSV of EQUIP_SUM tab from Blank Concept of Support Model UNCLASSIFIED aka Redonkulator
    and populates generic_inventory table with quantities of each equipment item expected to reside in various
    unit types; i.e. AAV Bn, Arty Bn, CAB, etc.
    :return: void
    """
    df = pd.read_csv('redonkulator_app/db/equip.csv')
    df.drop(df.iloc[:, 17:], axis=1, inplace=True)  # mpsron 3, 2, mpf total, le bn, and everything after
    df.drop(df.iloc[:, 14:16], axis=1, inplace=True)  # 4th Mar, 7th mar (all reg hq data comes from 3d mar)
    df.drop(df.iloc[:, 11:12], axis=1, inplace=True)  # tank bn
    df.drop(df.iloc[:, 1:3], axis=1, inplace=True)  # nomen, equip type
    df.dropna(subset=['TAMCN'], inplace=True)  # tamcn is only field requiring non-null.

    df.rename(columns={
        'AAV BN': 'AAV BN',
        'ARTILLERY BN': 'ARTY BN',
        'CBT ENG BN': 'CEB',
        'HIMARS BN (5/11)': 'HIMAR BN',
        'INFANTRY BN': 'INF BN',
        'DIV HQ BN': 'DIV HQ',
        '3D MARINES HQ CO': 'REGT HQ',
        '12 MARINES HQ BAT': 'ARTY REGT HQ',
    }, inplace=True)

    df['equipment_id'] = df.apply(tamcn_to_id, axis=1)
    df.drop('TAMCN', axis=1, inplace=True)

    engine = db.create_engine(f'mysql+mysqldb://{DB_USER}:{DB_PWD}@{DB_HOST}:{DB_PORT}/{DB_SCHEMA}')
    for col in df:
        unit_df = df[['equipment_id', col]].copy()
        unit_df.rename(columns={
            col: 'quantity'
        }, inplace=True)
        unit_df['unit_type'] = col
        unit_df.to_sql(name='generic_inventory', con=engine, schema='redonkulator', if_exists='append', index=False)


def tamcn_to_id(row):
    """
    Get equipment_id from TAMCN
    :param row: DataFrame row containing 'TAMCN' column.
    :return: equipment_id (integer)
    """
    tamcn = row['TAMCN']
    cnx = mysql.connector.connect(user=DB_USER, password=DB_PWD, host=DB_HOST, database=DB_SCHEMA)
    cur = cnx.cursor()
    sql = "select id from equipment where tamcn = %s"
    params = (tamcn,)
    cur.execute(sql, params)
    for equipment_id, in cur:
        return equipment_id


if __name__ == '__main__':
    # import_equip()
    import_generic_inventory()
