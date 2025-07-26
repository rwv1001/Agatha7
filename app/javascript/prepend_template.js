window.MyHash = function(){
  // private storage
  this.hash_table = {};

  // define each method on the instance itself
  this.set = function(key, value) {
    return this.hash_table[key] = value;
  };

  this.unset = function(key) {
    delete this.hash_table[key];
  };

  this.exists = function(key) {
    return key in this.hash_table;
  };

  this.get = function(key) {
    return this.exists(key) ? this.hash_table[key] : null;
  };
};


