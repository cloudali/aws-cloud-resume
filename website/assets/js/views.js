   /*-----------------------------------------------------------------
    Visitor Counter
    -------------------------------------------------------------------*/

    async function updateCounter() {
        const counter = document.getElementById("visitor");
          let response = await fetch("https://ivtom7z4ocfndyvs5f67dy2d7a0zsmrt.lambda-url.us-east-1.on.aws/");
          let data = await response.json();
          console.log(data);
          counter.innerHTML = `${data}`;
    
      }