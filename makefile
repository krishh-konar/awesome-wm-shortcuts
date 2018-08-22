all:
	gcc s.c -o s
	gcc n.c -o n
	gcc b.c -o b
	gcc v.c -o v
	gcc die.c -o die
clean: 
	rm -f s n b v kd.sh rsd.sh
install:
	cp s /bin
	cp n /bin
	cp b /bin
	cp v /bin
	cp die /bin
	cp rsd.sh /bin
	cp kd.sh /bin
	chown root /bin/s
	chown root /bin/b
	chown root /bin/die
	chmod 4755 /bin/s
	chmod 4755 /bin/b
	chmod 4755 /bin/die
	chmod 4755 /bin/kd.sh
	chmod 4755 /bin/rsd.sh
uninstall:
	rm /bin/s
	rm /bin/n
	rm /bin/b
	rm /bin/v
	rm /bin/die
	rm /bin/rsd.sh
	rm /bin/kd.sh

