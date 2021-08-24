require "json"
IGNORE = ["TEMPLATE", "htmls", "docs"]
team_names = Dir.glob('*').select {|f| !IGNORE.include?(f) and File.directory? f}

f = %Q{
  <html>
    <body>
      <h1>langjam0001 all <span id="num_projects"></span> projects shuffled</h1>
      <h4>refresh this page for a new team order</h4>

      <div id="entries">
      </div>
    </body>

    <script>
      var team_names = JSON.parse(`#{team_names.to_json}`);

      function shuffle(array) {
        var currentIndex = array.length,  randomIndex;
      
        // While there remain elements to shuffle...
        while (currentIndex != 0) {
      
          // Pick a remaining element...
          randomIndex = Math.floor(Math.random() * currentIndex);
          currentIndex--;
      
          // And swap it with the current element.
          [array[currentIndex], array[randomIndex]] = [
            array[randomIndex], array[currentIndex]];
        }
      
        return array;
      }

      shuffle(team_names);
      var numProjects = document.getElementById('num_projects');
      numProjects.innerHTML = `${team_names.length}`;

      var entriesEl = document.getElementById('entries');

      function loadIframe(div) {
        var iframe = document.createElement('iframe');
        iframe.src = div.dataset.src;
        iframe.width = "97%";
        iframe.height = "800px";
        div.parentNode.replaceChild(iframe, div);
      }

      function isInViewport(element) {
          const rect = element.getBoundingClientRect();
          return (
              rect.top >= 0 &&
              rect.left >= 0 &&
              rect.bottom <= (window.innerHeight || document.documentElement.clientHeight) &&
              rect.right <= (window.innerWidth || document.documentElement.clientWidth)
          );
      }      

      var observer = new IntersectionObserver(function(entries) {
        for (const entry of entries) {
          if (entry.isIntersecting === false) {
            return;
          }
          loadIframe(entry.target);
        }
      }, {threshold: [0]});

      for (const tn of team_names) {
        var h2 = document.createElement('h2');
        h2.innerHTML = `<a href="https://github.com/langjam/jam0001/tree/main/${tn}">${tn}</a> - <a href="https://github.com/langjam/jam0001/issues?q=team+${tn}">vote</a>`;
        entriesEl.appendChild(h2);

        var div = document.createElement('div');
        div.dataset.src = `htmls/${tn}.html`;
        entriesEl.appendChild(div);

        if (isInViewport(div)) {
          loadIframe(div);
        } else {
          observer.observe(div);
        }
    }
    </script>
  </html>
}



puts f

