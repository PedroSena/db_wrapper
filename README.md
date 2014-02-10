# db_wrapper #

## What is db_wrapper ? ##

db_wrapper is a Ruby gem that allows the creation of listeners to every database call you make in a transparent way.

## How does it work ? ##

It creates a super lightweight TCP proxy that will redirect every database call to the proxied database (in a **non blocking way**) to another process that will call the listeners you registered. Everything happens in a different process so the listeners won't impact the database query performance.

The fact that it works like a proxy allows you to create listeners without changing your application code and without needing to worry about performance.

## Which databases does it support ? ##

* Mysql
* PostgreSQL (future)
* MongoDB (future)

The protocol implementation is simple so you can easily extend it by yourself to support a
different database (and send me the pull request if you want)

## Next steps ##
* PostgreSQL protocol
* MongoDB protocol
* Examples and documentation
* Server listeners - Listeners that would get data sent from the server to the client, also in a non blocking way

## License and copyright ##

db_wrapper is copyrighted free software made available under the terms
of either the GPL or Ruby's License.

Copyright: (C) 2014 by Pedro Sena. All Rights Reserved.