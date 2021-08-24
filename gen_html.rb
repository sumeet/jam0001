require "json"

team_names = Dir.glob('*').select {|f| f != "TEMPLATE" and File.directory? f}

#team_names.each do |team_name|
#  iframes << %Q{
#    <iframe style="margin: auto;" width="98%" height="800px" src="htmls/#{team_name}.html">
#    </iframe>
#  }
#end

f = %Q{
  <html>
    <body>
      <h1>langjam0001 all <span id="num_projects"></span> projects shuffled. REFRESH for a new team order</h1>
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

      for (const tn of team_names) {
        var numProjects = document.getElementById('num_projects');
        numProjects.innerHTML = `${team_names.length}`;

        var h2 = document.createElement('h2');
        h2.innerHTML = tn;
        document.body.appendChild(h2);

        var iframe = document.createElement('iframe');
        iframe.src = `htmls/${tn}.html`;
        iframe.style = "margin: auto;";
        iframe.width = "98%";
        iframe.height = "800px";
        document.body.appendChild(iframe);
      }

    </script>
  </html>
}



puts f

