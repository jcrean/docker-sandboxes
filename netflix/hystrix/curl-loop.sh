while :; do 
  echo "8080: $(curl -XHEAD -Is http://localhost:8080/foo/bar+qux | head -n1)"
  echo "8081: $(curl -XHEAD -Is http://localhost:8081/foo/bar+qux | head -n1)"
done
