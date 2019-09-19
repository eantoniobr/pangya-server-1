#include "db.h"

Poco::Data::SessionPool pooling("ODBC", "DRIVER={SQL Server Native Client 11.0};Server=DESKTOP-2I33BP3;Database=Pangya;Trusted_Connection=Yes;MARS_Connection=Yes", 1, 32);

session get_session() {
	session sess = std::make_unique<Poco::Data::Session>(pooling.get());
	sess->setFeature("forceEmptyString", true);
	return sess;
}

void db_init() {
	Poco::Data::ODBC::Connector::registerConnector();
}

void db_final() {
	pooling.shutdown();
}