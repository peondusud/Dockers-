docker run -it --rm -p 8080:80 -p 50000:50000 -v /home/peon/tmpdocker:/home --name combo combo

To debug
docker run -it --rm -p 8080:80 -p 50000:50000 -v /home/peon/tmpdocker:/home --name combo combo bash
