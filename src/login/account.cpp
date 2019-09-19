#include "account.h"
#include "pc.h"
#include "clif.h"
#include "pcs.h"

#include "../common/typedef.h"
#include "../common/utils.h"
#include "../common/db.h"
#include "../common/packet.h"


void pc_req_login(pc* pc) {
	std::string username = RTSTR(pc);
	std::string password = RTSTR(pc);

	Statement query(*get_session());
	query << "SELECT account_id, username, password, state, name, first_set FROM account WHERE username = ?", use(username), now;
	RecordSet rs(query);


	// User is not found.
	if ( (rs.rowCount() <= 0) || !STRCMP(username, rs["username"].toString())) {
		sclif->login_msg(pc, USER_NOT_FOUND);
		pc->disconnect();
		return;
	}
	
	// Password is not match.
	if ( !STRCMP(password, rs["password"].toString()) ) {
		sclif->login_msg(pc, INCORRECT_PASSWORD);
		pc->disconnect();
		return;
	}

	// User is banned.
	if (rs["state"] > 0) {
		sclif->login_msg(pc, USER_STATE_BAN);
		pc->disconnect();
		return;
	}

	pc->set_accountid(rs["account_id"]);
	pc->set_username(rs["username"]);
	pc->set_name(rs["name"]);

	if (rs["first_set"] == 0) {
		sclif->send_firstset(pc);
		return;
	}

	sys_send_data(pc);
}

// Return true	: Name is not existed
// Return false : Name is already existed
bool sys_name_validation(std::string& name) {
	Statement stm(*get_session());
	stm << "SELECT 1 FROM account WHERE name = ?", use(name), now;
	RecordSet rs(stm);

	if (rs.rowCount() <= 0) {
		return true;
	}

	return false;
}

void pc_checkup_name(pc* pc) {
	std::string name = RTSTR(pc);

	if (sys_name_validation(name)) {
		sclif->send_name_available(pc, name);
		return;
	}

	sclif->send_name_taken(pc);
}

void pc_check_available(pc* pc) {
	std::string name = RTSTR(pc);

	if (sys_name_validation(name)) {
		pc->set_name(name);
		sclif->send_name_validate_true(pc);
		return;
	}

	sclif->send_name_validate_failed(pc);
}

void pc_req_create_char(pc* pc) {
	uint32 char_typeid = RTIU32(pc);
	uint16 hair_colour = RTIU16(pc);

	int error_code = 0;

	Statement stm(*get_session());
	stm << "EXEC sys_firstset ?, ?, ?, ?", bind(pc->get_accountid()), bind(pc->get_name()), use(char_typeid), use(hair_colour), into(error_code), now;
	
	//// error occurred
	if (error_code > 0) {
		pc->disconnect();
		return;
	}

	Packet p;
	WTHEAD(&p, 0x11);
	WTIU08(&p, 0);
	pc->send_packet(&p);

	sys_send_data(pc);
}

void sys_send_data(pc* pc) {
	std::string game_key = rnd_str(7);
	std::string login_key = rnd_str(7);

	Statement stm(*get_session());
	stm << "UPDATE account SET game_key = ?, login_key = ?, logincount += 1, lastlogin = GETDATE() WHERE account_id = ?", 
		use(game_key), use(login_key), bind(pc->get_accountid()), now;

	pc->login_key = login_key;
	pc->game_key = game_key;

	sclif->send_auth_login(pc);
	sclif->send_pc_data(pc);
	sclif->send_game_server(pc);

	// TODO: should send messenger server
}

void pc_req_gamekey(pc* pc) {
	Packet p;
	WTHEAD(&p, 0x03);
	WTIU32(&p, 0);
	WTCSTR(&p, pc->game_key);
	pc->send_packet(&p);
}