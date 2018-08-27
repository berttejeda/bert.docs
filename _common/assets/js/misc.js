// date functions
Date.prototype.yyyymmdd = function() {
  var mm = this.getMonth() + 1; // getMonth() is zero-based
  var dd = this.getDate();

  return [this.getFullYear(),
          (mm>9 ? '' : '0') + mm,
          (dd>9 ? '' : '0') + dd
         ].join('');
};

function heredoc(fn) {
  return fn.toString().match(/\/\*\s*([\s\S]*?)\s*\*\//m)[1];
};


function flash(selector, duration) {
	$(selector).fadeIn(duration).fadeOut(duration).fadeIn(duration).fadeOut(duration).fadeIn(duration);
}
