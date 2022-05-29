
window.web3 = new Web3(ethereum);


const xhr = new XMLHttpRequest()

function getWalletNumber () {
  if (window.ethereum) {
      window.web3 = new Web3(ethereum);
      ethereum.enable()
          .then(() => {
              console.log("Ethereum enabled");
              web3.eth.getAccounts(function (err, acc) {
                  if (err != null) {
                      self.setStatus("There was an error fetching your accounts");
                      return;
                  }
                  if (acc.length > 0) {
                      console.log(acc);

                      var tosend= {
                          "account-address": acc[0]
                      }
                      const myJSON = JSON.stringify(tosend);

                      xhr.open("POST", "/user/login", false);
                      xhr.setRequestHeader("Content-type", "application/json");
                      xhr.send(myJSON);
                      var res;
                      res = JSON.parse(xhr.responseText)
                      res_code = xhr.status
                      console.log(res_code);
                      if (res_code === 401)
                      {
                          document.getElementById("login_fail").style.display = "block";
                      }
                      else if(res_code === 200){
                          console.log("aaj aana");
                          window.location.replace("/home");
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
}


function lol1()
{

	console.log("lol1")

}
function close_alert()
{
      {
          document.getElementById("login_fail").style.display = "none";
      }
}
function submit()
{
    console.log("hi")
}