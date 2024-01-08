   /*-----------------------------------------------------------------
    Visitor Counter
    -------------------------------------------------------------------*/

    async function updateCounter() {
        const counter = document.getElementById("visitor");
          let response = await fetch("https://2ssl447l52qicn3paqeqj4g6km0kydsl.lambda-url.us-east-1.on.aws/");
          let data = await response.json();
          console.log(data);
          counter.innerHTML = `${data}`;
    
      }