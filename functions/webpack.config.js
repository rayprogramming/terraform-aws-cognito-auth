const path = require('path');
const glob = require('glob');

module.exports = {
  mode: 'development',
  target: 'node',
  module: {
    rules: [
      {exclude: [path.resolve(__dirname, 'node_modules')], loader: 'babel-loader', test: /\.jsx?$/}
    ],
  },
	entry: glob.sync('./src/*.js').reduce(function(obj, el){
     obj[path.parse(el).name] = el;
     return obj
  },{}),
	output: {
		path: __dirname + '/dist',
		filename: '[name].js',
	}
};
