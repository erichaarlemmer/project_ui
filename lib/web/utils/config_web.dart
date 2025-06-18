const String ipAddr = String.fromEnvironment('IP_ADDRESS', defaultValue: 'localhost');

const String port = "8000";

const String httpServerAddress = "http://$ipAddr:$port";
const String wsServerAddress = "ws://$ipAddr:$port/ws/login/";
