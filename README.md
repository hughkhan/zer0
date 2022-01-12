# zer0

In order to obtain a valid jwt token need to log in with one of the users:

curl -XPOST 'localhost:80/login' -H 'Content-Type: application/json' -d '{"email": "TH@poetrysociety.org", "password": "password"}'

You can create a new user:

curl -XPOST 'localhost:80/register' -H 'Content-Type: application/json' -d '{"first_name": "Tom", "last_name": "Stoppard", "email": "TS@poetrysociety.org", "password": "password"}'

List projects.  If logged in then can see private projects you belong to.  If not logged in then only public projects are visible

curl -XPOST 'localhost:80/project/list' -H 'Content-Type: application/json' -d '{"token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6Ik9XQHBvZXRyeXNvY2lldHkub3JnIiwiaWF0IjoxNjQyMDE0ODAxLCJleHAiOjE2NDIwMjIwMDF9.Nsu3-QGuHvOPjdRsSTySDxjQ1Au53GC08xfHxhfccbU"}'

You can list projects by a member.  Only Public projects are listed.  If the member is logged then the private projects the member belongs to are also listed.

curl -XPOST 'localhost:80/project/list/TH@poetrysociety.org' -H 'Content-Type: application/json' -d '{"token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6Ik9XQHBvZXRyeXNvY2lldHkub3JnIiwiaWF0IjoxNjQyMDE0ODAxLCJleHAiOjE2NDIwMjIwMDF9.Nsu3-QGuHvOPjdRsSTySDxjQ1Au53GC08xfHxhfccbU"}'
