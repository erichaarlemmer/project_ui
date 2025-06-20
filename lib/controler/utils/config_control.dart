const String ipAddr = String.fromEnvironment('IP_ADDRESS', defaultValue: 'localhost');

const String port = "8000"; 
const String clientId = "controler_123";
const String wsServerAddress = "ws://$ipAddr:$port/ws/control/";
const String httpServerAddress = "http://$ipAddr:$port";