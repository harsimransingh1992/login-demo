<link rel="icon" type="image/svg+xml" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%233498db'><path d='M12 2C10.5 2 9 3.5 9 5C9 6.5 10.5 8 12 8C13.5 8 15 6.5 15 5C15 3.5 13.5 2 12 2ZM12 10C10.5 10 9 11.5 9 13C9 14.5 10.5 16 12 16C13.5 16 15 14.5 15 13C15 11.5 13.5 10 12 10ZM12 18C10.5 18 9 19.5 9 21C9 22.5 10.5 24 12 24C13.5 24 15 22.5 15 21C15 19.5 13.5 18 12 18Z'/></svg>">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<script>
// Production-safe console gating: quiet verbose logs unless debugging
(function(){
  var isLocal = location.hostname === 'localhost' || location.hostname === '127.0.0.1';
  var debugEnabled = isLocal || localStorage.getItem('pdDebug') === '1';
  window.__PD_DEBUG__ = !!debugEnabled;
  if (!debugEnabled) {
    ['log','debug','info','warn'].forEach(function(m){
      try { console[m] = function(){}; } catch(e) {}
    });
  }
})();
</script>
<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>