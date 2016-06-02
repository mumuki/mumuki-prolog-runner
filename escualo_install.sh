#/bin/bash
REV=$1

echo "[Escualo::PlunitServer] Fetching GIT revision"
echo -n $REV > version

echo "[Escualo::PlunitServer] Pulling docker image"
docker pull mumuki/mumuki-plunit-worker