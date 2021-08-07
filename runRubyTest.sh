python -m SimpleHTTPServer 8888 &
pid=$!
ruby ruby_single.rb
kill $pid
