FarHorizonsChase
================

Chase vehicle web site with Ruby 2.0 on Rails 4.0 framework.

Used Ruby Version Manager (rvm) version 1.19

Created gemset "fh" under ruby 2.0

rvm use 2.0
rvm gemset create fh

mkdir <project name>

cd <project name>
echo fh > .ruby-gemset
echo 2.0 > .ruby-version

Install rails 4.0 to gemset fh
gem install rails 4.0

<em>Database</em>

Redis DB is used for short-term database needs.

Main database is MongoDb using MongoMapper.

<em>Initial model creation</em>

rails generate mongo_mapper:model <model> <key:type ...>

<em>Initial framework</em>

Used rails built-in scaffolding for initial framework:
rails generate scaffold <model> <key:type ...>

NOTE: The scaffold-generated code uses the blah.update() method in the "update"
controller action method. This is a private method in MongoMapper and it was
manually replaced with the blah.set() method.

<em>Serial IO with the 'serialport' gem</em>

NOTE: ruby-serialport seems to conflict with serialport, so find and delete
ruby-serialport directories in the 2.0@fh gemset directory.

<em>Real-time data collection</em>

Managed by script drivers in /bin directory.

Initiated by
(REF: http://stackoverflow.com/questions/11982057):

    Process.detach( pid = spawn( "bin/<script name>" )

Terminated by 

    Process.kill( 'TERM', pid )

"pid" is stored as a key in the model associated with the drive.

NOTE: Since the APRS and GPS device drivers need to create points via an API
rather than form input, We have to bypass the Rails authenticity token
machinery for the POST (create) method in the points_controller.

Also, since tracking devices (location_devices, beacons) have a dedicated point
document associated with them, they have point initialization method invoked
in after_create and as such, the 'new' method won't initilize, so the 'create'
method must be called instead.

