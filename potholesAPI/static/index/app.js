// const xhr = new XMLHttpRequest()
window.web3 = new Web3(ethereum);

const abi = [
	{
		"constant": true,
		"inputs": [],
		"name": "name",
		"outputs": [
			{
				"name": "",
				"type": "string"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "spender",
				"type": "address"
			},
			{
				"name": "tokens",
				"type": "uint256"
			}
		],
		"name": "approve",
		"outputs": [
			{
				"name": "success",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "totalSupply",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "from",
				"type": "address"
			},
			{
				"name": "to",
				"type": "address"
			},
			{
				"name": "tokens",
				"type": "uint256"
			}
		],
		"name": "transferFrom",
		"outputs": [
			{
				"name": "success",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "decimals",
		"outputs": [
			{
				"name": "",
				"type": "uint8"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "_totalSupply",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_burnAmount",
				"type": "uint256"
			}
		],
		"name": "burn",
		"outputs": [],
		"payable": true,
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "tokenOwner",
				"type": "address"
			}
		],
		"name": "balanceOf",
		"outputs": [
			{
				"name": "balance",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "symbol",
		"outputs": [
			{
				"name": "",
				"type": "string"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_mintAmount",
				"type": "uint256"
			}
		],
		"name": "mint",
		"outputs": [],
		"payable": true,
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "a",
				"type": "uint256"
			},
			{
				"name": "b",
				"type": "uint256"
			}
		],
		"name": "safeSub",
		"outputs": [
			{
				"name": "c",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "to",
				"type": "address"
			},
			{
				"name": "tokens",
				"type": "uint256"
			}
		],
		"name": "transfer",
		"outputs": [
			{
				"name": "success",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "_owner",
		"outputs": [
			{
				"name": "",
				"type": "address"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "a",
				"type": "uint256"
			},
			{
				"name": "b",
				"type": "uint256"
			}
		],
		"name": "safeDiv",
		"outputs": [
			{
				"name": "c",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "spender",
				"type": "address"
			},
			{
				"name": "tokens",
				"type": "uint256"
			},
			{
				"name": "data",
				"type": "bytes"
			}
		],
		"name": "approveAndCall",
		"outputs": [
			{
				"name": "success",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "a",
				"type": "uint256"
			},
			{
				"name": "b",
				"type": "uint256"
			}
		],
		"name": "safeMul",
		"outputs": [
			{
				"name": "c",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "tokenOwner",
				"type": "address"
			},
			{
				"name": "spender",
				"type": "address"
			}
		],
		"name": "allowance",
		"outputs": [
			{
				"name": "remaining",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "a",
				"type": "uint256"
			},
			{
				"name": "b",
				"type": "uint256"
			}
		],
		"name": "safeAdd",
		"outputs": [
			{
				"name": "c",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"name": "from",
				"type": "address"
			},
			{
				"indexed": true,
				"name": "to",
				"type": "address"
			},
			{
				"indexed": false,
				"name": "tokens",
				"type": "uint256"
			}
		],
		"name": "Transfer",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"name": "tokenOwner",
				"type": "address"
			},
			{
				"indexed": true,
				"name": "spender",
				"type": "address"
			},
			{
				"indexed": false,
				"name": "tokens",
				"type": "uint256"
			}
		],
		"name": "Approval",
		"type": "event"
	}
]
const add= "0x5a3493dDaBD046a70666AB757F81c88E73Aa4616"
const c = new web3.eth.Contract(abi,add)
var reso;


window.addEventListener('load', function () {
  if (window.ethereum) {
      window.web3 = new Web3(ethereum);
      ethereum.enable()
          .then(() => {
              console.log("Ethereum enabled");
              web3.eth.getAccounts(function (err, acc) {
				  console.log("hi owais1")
                  if (err != null) {
                      self.setStatus("There was an error fetching your accounts");
                      return;
                  }
                  if (acc.length > 0) {

                      console.log(acc);
                      // c.methods.balanceOf(acc[0]).call().then((res)=>{
                      //   console.log(res)
						//   document.getElementById("balance").innerHTML ="SST " + res;
                      // })
  						var tosend= {
                          "account-address": acc[0]
                      }
                      const myJSON = JSON.stringify(tosend);
						console.log("hi owais")
                      xhr.open("POST", "/user/login", false);
                      xhr.setRequestHeader("Content-type", "application/json");
                      xhr.send(myJSON);
                      var res;
                      res = JSON.parse(xhr.responseText)
                      res_code = xhr.status
                      console.log(res_code);

					  if (res_code === 200){
						   document.getElementById("balance").innerHTML ="SST " + res["tokens"];

						   if(res["cert-path"] != null)
						   {
								document.getElementById("cert-button").innerHTML = "View Certificate"
								document.getElementById("cert-button").className= "btn btn-primary btn-sm d-none d-sm-inline-block enabled"
							   reso=res;
							   document.getElementById("cert-button").onclick= view_cert
						   }
						   else if (res["tokens"] >= 200 )
						   {
								document.getElementById("cert-button").className= "btn btn-primary btn-sm d-none d-sm-inline-block enabled"
							   reso=res;
							   document.getElementById("cert-button").onclick= generate_cert


						   }

					  }


                  }
              });
          })
          .catch(() => {
              // console.warn('User didn't allow access to accounts.');
              // waitLogin();
          });
  } else {
      console.log("Non-Ethereum browser detected. You should consider installing MetaMask.");
  }
});



function view_cert()
{
	var url= "https://ipfs.infura.io/ipfs/" + reso["cert-path"]
	window.location.replace(url);
}
function generate_cert()
{
					var tosend= {
                          "account-address": reso["account-address"]
                      }
                      const myJSON = JSON.stringify(tosend);
						console.log("hi owais")
                      xhr.open("POST", "/user/addCert", false);
                      xhr.setRequestHeader("Content-type", "application/json");
                      xhr.send(myJSON);
                      var res1;
                      res1 = JSON.parse(xhr.responseText)
						console.log(res1)



					xhr.open("POST", "/user/fetchCert", false);
                      xhr.setRequestHeader("Content-type", "application/json");
                      xhr.send(myJSON);
					  var res2;
						res2 = JSON.parse(xhr.responseText)
					var url= "https://ipfs.infura.io/ipfs/" + res2
					window.location.replace(url);


}
