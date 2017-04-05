all:
	gcc s.c -o s
	gcc n.c -o n
	gcc b.c -o b
	gcc v.c -o v
	gcc die.c -o die
clean: 
	rm -f s n b v
install:
	cp s /bin
	cp n /bin
	cp b /bin
	cp v /bin
	cp die /bin
	chown root /bin/s
	chown root /bin/b
	chown root /bin/die
	chmod 4755 /bin/s
	chmod 4755 /bin/b
	chmod 4755 /bin/die
uninstall:
	rm /bin/s
	rm /bin/n
	rm /bin/b
	rm /bin/v
	rm /bin/die
