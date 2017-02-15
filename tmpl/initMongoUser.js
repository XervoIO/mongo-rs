db = db.getSiblingDB('admin');
db.createUser({
  user: '{{mongo.username}}',
  pwd: '{{mongo.password}}',
  roles: [
    'userAdminAnyDatabase',
    'dbAdminAnyDatabase',
    'readWriteAnyDatabase',
    'clusterAdmin'
  ]
});
