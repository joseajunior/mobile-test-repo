import os
from pathlib import Path
import configparser
from otr_robot_lib.BaseStartup import BaseStartup

EFS_SECTION = 'efs'
IRVING_IMPERIAL_SHELL_SECTION = 'irving_imperial_shell'
LOCATIONS_SECTION = 'locations'
ROBOT_USER_DATA_SECTION = 'robot_user_data'
CARDS_SECTION = 'cards'

STATIC_VARIABLES_PATH = "Variables/static_variables.properties"


def get_variables(config=None, env_override=None):
    """
    This compiles all variables as a dictionary which is returned to robot. This will allow us to dynamically update variables
    :param arg1: This is the enrionment variable that will determine what variables are loaded valid options are:
    acpt
    dit
    sit
    stage
    aws-dit
    aws-sit
    :param config:
    :param env_override:
    :return: dictionary of variables
    """
    import time
    start = BaseStartup()
    vars = start.get_common_variables(config, env_override)
    vars.update(_get_cards())
    vars.update(_robot_user_data())
    now = time.time()
   


    print("DBs Connected and Dynamic Variables Loaded.\nElapsed time: {elapsed}s".format(elapsed=time.time() - now))
    return vars


def _get_root():
    return str(Path(__file__).parent.parent)


def _get_efs(print_variables=False):
    vars = {}
    static_variables_file = _get_static_variables_file()
    vars["userName"] = _get_from_file(static_variables_file, EFS_SECTION, 'userName')
    vars["contract"] = _get_from_file(static_variables_file, EFS_SECTION, 'contract')
    vars["sec_contract"] = _get_from_file(static_variables_file, EFS_SECTION, 'sec_contract')
    vars["efs_carrier"] = _get_from_file(static_variables_file, EFS_SECTION, 'efs_carrier')
    vars["efs_mastercard_contract"] = _get_from_file(static_variables_file, EFS_SECTION, 'efs_mastercard_contract')
    vars["pnc_contract"] = _get_from_file(static_variables_file, EFS_SECTION, 'efs_carrier')         # PNC
    vars["FLTCarrier"] = _get_from_file(static_variables_file, EFS_SECTION, 'FLTCarrier')            # FLT-1 info
    vars["FLTContract"] = _get_from_file(static_variables_file, EFS_SECTION, 'FLTContract')
    vars["usertier"] = _get_from_file(static_variables_file, EFS_SECTION, 'usertier')                # Carrier Group Tier's login and password
    vars["user_ref"] = _get_from_file(static_variables_file, EFS_SECTION, 'user_ref')                # Referral Level management's login and password
    vars["user_deal"] = _get_from_file(static_variables_file, EFS_SECTION, 'user_deal')              # Managed deals logim and password
    vars["reskin_carrier"] = _get_from_file(static_variables_file, EFS_SECTION, 'reskin_carrier')    # Shell Reskin carrier and password

    # PASSWORDS FROM DB
    from otr_model_lib.Models import ms
    user = ms.get_member_model(vars["userName"])
    FLTCarrier = ms.get_member_model(vars["FLTCarrier"])
    usertier = ms.get_member_model(vars["usertier"])
    user_ref = ms.get_member_model(vars["user_ref"])
    user_deal = ms.get_member_model(vars["user_deal"])
    reskin_carrier = ms.get_member_model(vars["reskin_carrier"], db_instance='shell')

    vars["reskin_password"] = reskin_carrier.password
    vars["passwd_deal"] = user_deal.password
    vars["pass_ref"] = user_ref.password
    vars["passtier"] = usertier.password
    vars["FLTPassword"] = FLTCarrier.password
    vars["password"] = user.password
    _print_variables(print_variables, "EFS", vars)
    return vars


def _get_cards(print_variables=False):
    print("Getting Dynamic Cards Data...")
    vars={}
    from otr_model_lib.Models import cs
    static_variables_file = _get_static_variables_file()
    vars["Pin"] = _get_from_file(static_variables_file, CARDS_SECTION, 'Pin')
    vars["validCard"] = cs.get_valid_card()
    # vars["UniversalCard"] = cs.get_universal_card()
    # vars["efs_fleet_card"] = cs.get_efs_fleet_card()      # El Robot Cards
    _print_variables(print_variables, "Cards", vars)
    return vars


def _get_locations(print_variables=False):
    vars = {}
    static_variables_file = _get_static_variables_file()
    vars["validLoc"] = _get_from_file(static_variables_file, LOCATIONS_SECTION, 'validLoc')
    _print_variables(print_variables, "Locations", vars)
    return vars


def _get_irving_imperial_shell(print_variables=False):
    """
    Irving, Imperial, and Shell info is the same accross acpt and devacpt
    :param envir:
    :return:
    """
    vars = {}
    static_variables_file = _get_static_variables_file()
    vars["irvinguserName"] = _get_from_file(static_variables_file, IRVING_IMPERIAL_SHELL_SECTION, 'irvinguserName')
    vars["shell_carrier"] = _get_from_file(static_variables_file, IRVING_IMPERIAL_SHELL_SECTION, 'shell_carrier')

    # PASSWORDS FROM DB
    from otr_model_lib.Models import ms
    irvinguserName = ms.get_member_model(vars["irvinguserName"], db_instance='irving')
    shell_carrier = ms.get_member_model(vars["shell_carrier"], db_instance='shell')  # OLD CODE IS CONNECTING TO IMPERIAL DB TO GET THIS PASSWORD

    vars["irvingpassword"] = irvinguserName.password
    vars["shell_password"] = shell_carrier.password
    _print_variables(print_variables, "Irving, Imperial and Shell", vars)
    return vars


def _robot_user_data(print_variables=False):
    vars = {}
    static_variables_file = _get_static_variables_file()
    vars["ROBOTROOT"] = _get_root()
    vars["REPORTSDIR"] = _get_from_file(static_variables_file, ROBOT_USER_DATA_SECTION, 'REPORTSDIR')
    _print_variables(print_variables, "Robot User Data", vars)
    return vars


def _get_static_variables_file():
    file_dir = os.path.dirname(os.path.abspath(__file__))
    file_dir = os.path.dirname(file_dir)
    abs_file_path = os.path.join(file_dir, STATIC_VARIABLES_PATH)
    # print(abs_file_path)
    config_parser = configparser.RawConfigParser()
    config_parser.read(abs_file_path)
    return config_parser


def _get_from_file(env_file, section, key):
    try:
        value = env_file.get(section, key)
        if not value:
            return None
    except Exception as e:
        print(e)
    return value


def _print_variables(print_variables, scope, vars):
    if print_variables:
        print("{0} Variables Are:".format(scope))
        for var in vars.keys():
            print("\t" + var + ": " + str(vars[var]))


if __name__ == '__main__':
    import time
    now = time.time()
    get_variables(None, 'aws-dit')
    print(time.time() - now)
