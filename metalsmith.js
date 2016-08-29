var Metalsmith = require('metalsmith');
var markdown = require('metalsmith-markdown');
var layouts = require('metalsmith-layouts');
var jade = require('metalsmith-jade');
var branch = require('metalsmith-branch');
var changed = require('metalsmith-changed');

const htmlToSlides = require('./htmlToSlides.js');

console.log("Starting...");
Metalsmith(__dirname)
	.clean(false) // don't destroy `build` dir every time
	// .use(changed()) // only write changed files
	.source(__dirname + "/src")
	.destination(__dirname + "/build")
	.use(markdown())
	.use(branch()
		.pattern("!index.html")
		.use(branch()
			.pattern("**/*.html")
			.use(htmlToSlides())
			.use(layouts({
				engine: "jade",
				default: "slides.jade",
				directory: "layouts"
			}))
		)
	)
	.use(markdown())
	.build(function(err) {
		if (err) throw err;
		console.log("Finished!");
	})
