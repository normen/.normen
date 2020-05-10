## js-neuralnet
```
# neural net
npm install brain
npm install one-hot

# brain
const Brain = require('brain');
var mind = new Brain.NeuralNetwork();
var data = [{input: [1,2,3], output: [4,5,6]},{input: [2,3,4], output: [5,6,7]}];
mind.train(data,{
        errorThresh: 0.00005,  // error threshold to reach
        iterations: 20000,   // maximum training iterations
        log: true,           // console.log() progress periodically
        logPeriod: 1,       // number of iterations between logging
        learningRate: 0.3    // learning rate
    });
var prediction = mind.predict([3,4,5]);

var json = mind.toJSON();
mind.fromJSON(json);

# flatten any data to numbers
const OneHot = require('one-hot');
var oneHot = new OneHot();
var testIVs = [
  [0, 1, 2, 'a', 3],
  [3, 4, 5, 'b', 6],
  [6, 7, 8, 'c', 9]
];
oneHot.analyze(testIVs, function(err) {
  if (err) throw err;
  oneHot.encode(testIVs, function(err, encodedData) {
    if (err) throw err;
    console.log(encodedData);
  });
});

var originalColumns = ['one', 'two', 'three', 'char', 'four'];
console.log(oneHot.getColumnsHeader(originalColumns)); // ['one', 'two', 'three', 'char:a', 'char:b']
console.log(oneHot.getColumnsHeader()); // [null, null, null, '3:a', '3:b']
```
