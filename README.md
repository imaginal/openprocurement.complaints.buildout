OpenProcurement complaints buildout
===================================

This software sync tender complaints with mysql backend


### Requirements

- python 2.7
- MySQLdb


### Installation

    $ cd openprocurement.complaints.buildout
    $ python bootstrap.py
    $ bin/buildout


### Configuration

- etc/complaints.ini


### Start / Stop

    $ bin/complaintsd etc/complaints.ini 

or

    # /etc/init.d/complaints-queue {start|stop|restart|force-reload|status}

### Copyright

- Volodymyr Flonts <flyonts@gmail.com> E-DEMOCRACY NGO

