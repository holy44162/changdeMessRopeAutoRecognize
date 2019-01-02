% connect to the server
t = tcpip('localhost', 50007);
fopen(t);
% write a message
fwrite(t, 'This is a test message.');
% read the echo
bytes = fread(t, [1, t.BytesAvailable]);
char(bytes)
% close the connection
fclose(t);