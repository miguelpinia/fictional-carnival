// Ejecutando en node
// npm install gananche-cli
// npm install solcjs
// npm install web3@0.20.0

// Sending eths
Web3 = require('web3')
web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));

var account1 = "0xbaefa5ac5cab3a21afcb386e7ef076c478aa3934";
var account2 = "0x781eff13ae3eda0b23cc9015eadaef573c5323df";
var tx = {from:ac1,to:ac2,value:10000000000000000000};
web3.eth.sendTransaction(tx);



var accounts = web3.eth.accounts;
// web3.eth.getAccounts().then(accts => {accounts = accts});
var code = fs.readFileSync('voting.sol').toString();
solc = require('solc');
compiledCode = solc.compile(code);
compiledCode.contracts[':Voting'].bytecode;
compiledCode.contracts[':Voting'].interface;
abiDefinition = JSON.parse(compiledCode.contracts[':Voting'].interface);
VotingContract = web3.eth.contract(abiDefinition);
byteCode = compiledCode.contracts[':Voting'].bytecode;
deployedContract = VotingContract.new(['Juan','Miguel','Jose'],
                                      {data: byteCode,
                                       from: web3.eth.accounts[0],
                                       gas: 4700000});
deployedContract.address;
contractInstance = VotingContract.at(deployedContract.address);
contractInstance.totalVotesFor.call('Miguel');
contractInstance.voteForCandidate('Miguel', {from: web3.eth.accounts[0]});
contractInstance.voteForCandidate('Miguel', {from: web3.eth.accounts[0]});
contractInstance.voteForCandidate('Miguel', {from: web3.eth.accounts[0]});
contractInstance.totalVotesFor.call('Miguel').toLocaleString()
