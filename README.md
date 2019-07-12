# DSSG Project Website Template

This is a template for a public [gh-pages](https://pages.github.com/) webpage for DSSG summer projects which can be freely hosted online.

* Import this template into a new repo using the [repo importer](https://help.github.com/en/articles/importing-a-repository-with-github-importer) (a data scientist with permissions can set this up)
  * for simplicity we will keep them separate from your code 
  * we will import them under the uwescience organization

* The name of the repository will generate the name of the website
	* [https://uwescience.github.io/DSSG-website-template/](https://uwescience.github.io/DSSG-website-template/)

* Modify your project name in the `_config.yml` file

* Enable the gh-pages publishing source (use master branch):
	* [https://help.github.com/en/articles/configuring-a-publishing-source-for-github-pages](https://help.github.com/en/articles/configuring-a-publishing-source-for-github-pages)

* Each page is a markdown document
	* Markdown is a text marking language designed for the web 
		* [Markdown Tutorial](https://daringfireball.net/projects/markdown/syntax)
	
	* You can modify the markdown documents from the website (hit the edit button and commit when finished)
    	* You can also clone the repo (or your fork of it) and make modifications locally
		* [Macdown Editor for Mac](https://macdown.uranusjr.com/)
		* [MarkdownPad for Windows](http://markdownpad.com/news/2013/introducing-markdownpad-2/)
		* [Atom editor](https://atom.io/) has a markdown extension
	
* You can modify your pages by setting up the sidebar:

	* [https://github.com/uwescience/DSSG-website-template/blob/master/_includes/sidebar.html](https://github.com/uwescience/DSSG-website-template/blob/master/_includes/sidebar.html)


* Images go into [assets/img](https://github.com/uwescience/DSSG-website-template/tree/master/assets/img)
	* they can be accessed by:
	
        	
			<img src="{{ site.url }}{{ site.baseurl }}/assets/img/eScience.png">
		
	
	* feel free to have a different header image relevant to your project

* You can also test the website locally, but that requires setting up Jekyll:
		[https://jekyllrb.com/](https://jekyllrb.com/)

* If you do not want to rush make your writings visible on the website, you can work in a fork, or simply work on a local markdown file which you can share with your teammates for review. 




# Hyde Theme Details

Hyde is a brazen two-column [Jekyll](http://jekyllrb.com) theme that pairs a prominent sidebar with uncomplicated content. It's based on [Poole](http://getpoole.com), the Jekyll butler.

![Hyde screenshot](https://f.cloud.github.com/assets/98681/1831228/42af6c6a-7384-11e3-98fb-e0b923ee0468.png)


## Contents

- [Usage](#usage)
- [Options](#options)
  - [Sidebar menu](#sidebar-menu)
  - [Sticky sidebar content](#sticky-sidebar-content)
  - [Themes](#themes)
  - [Reverse layout](#reverse-layout)
- [Development](#development)
- [Author](#author)
- [License](#license)


## Usage

Hyde is a theme built on top of [Poole](https://github.com/poole/poole), which provides a fully furnished Jekyll setup—just download and start the Jekyll server. See [the Poole usage guidelines](https://github.com/poole/poole#usage) for how to install and use Jekyll.


## Options

Hyde includes some customizable options, typically applied via classes on the `<body>` element.


### Sidebar menu

Create a list of nav links in the sidebar by assigning each Jekyll page the correct layout in the page's [front-matter](http://jekyllrb.com/docs/frontmatter/).

```
---
layout: page
title: About
---
```

**Why require a specific layout?** Jekyll will return *all* pages, including the `atom.xml`, and with an alphabetical sort order. To ensure the first link is *Home*, we exclude the `index.html` page from this list by specifying the `page` layout.


### Sticky sidebar content

By default Hyde ships with a sidebar that affixes it's content to the bottom of the sidebar. You can optionally disable this by removing the `.sidebar-sticky` class from the sidebar's `.container`. Sidebar content will then normally flow from top to bottom.

```html
<!-- Default sidebar -->
<div class="sidebar">
  <div class="container sidebar-sticky">
    ...
  </div>
</div>

<!-- Modified sidebar -->
<div class="sidebar">
  <div class="container">
    ...
  </div>
</div>
```


### Themes

Hyde ships with eight optional themes based on the [base16 color scheme](https://github.com/chriskempson/base16). Apply a theme to change the color scheme (mostly applies to sidebar and links).

![Hyde in red](https://f.cloud.github.com/assets/98681/1831229/42b0b354-7384-11e3-8462-31b8df193fe5.png)

There are eight themes available at this time.

![Hyde theme classes](https://f.cloud.github.com/assets/98681/1817044/e5b0ec06-6f68-11e3-83d7-acd1942797a1.png)

To use a theme, add anyone of the available theme classes to the `<body>` element in the `default.html` layout, like so:

```html
<body class="theme-base-08">
  ...
</body>
```

To create your own theme, look to the Themes section of [included CSS file](https://github.com/poole/hyde/blob/master/public/css/hyde.css). Copy any existing theme (they're only a few lines of CSS), rename it, and change the provided colors.

### Reverse layout

![Hyde with reverse layout](https://f.cloud.github.com/assets/98681/1831230/42b0d3ac-7384-11e3-8d54-2065afd03f9e.png)

Hyde's page orientation can be reversed with a single class.

```html
<body class="layout-reverse">
  ...
</body>
```


## Development

Hyde has two branches, but only one is used for active development.

- `master` for development.  **All pull requests should be submitted against `master`.**
- `gh-pages` for our hosted site, which includes our analytics tracking code. **Please avoid using this branch.**


## Author

**Mark Otto**
- <https://github.com/mdo>
- <https://twitter.com/mdo>


## License

Open sourced under the [MIT license](LICENSE.md).

<3
