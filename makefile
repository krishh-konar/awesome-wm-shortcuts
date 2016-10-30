all:
	gcc s.c -o s
	gcc n.c -o n
clean: 
	rm -f s n
install:
	cp s /bin
	cp n /bin
	chown root /bin/s
	chmod 4755 /bin/s
uninstall:
	rm /bin/s
	rm /bin/n
