# DSSG Project Website Template

This is a template for a public [gh-pages](https://pages.github.com/) webpage for DSSG summer projects which can be freely hosted online.

Github Pages are static webpages, i.e. the content (mainly `.html` and `.css`) is sent to the user's browser and executed there (no backend server). That said, they actually can contain some interactive content which is in `.javascript`. The advantage is that one does not need to know these languages, all we need is to write text in `markdown` (thanks to numerous options of [Jekyll Templates](https://jekyllrb.com/))  Github Pages can be used for a lot of different scenarios:
* examples of older DSSG projects: [Food Safety Project](https://uwescience.github.io/DSSG2016-UnsafeFoods/), [Disaster Damage Detection Project](https://dds-lab.github.io/disaster-damage-detection/)

* example of tutorial content: [git novice lesson](http://swcarpentry.github.io/git-novice/), [lesson template](https://github.com/carpentries/lesson-example)

* example of a personal blog: [academic blog template](https://valentina-s.github.io/personal-website-template/)
* example of a class website: [example](https://valentina-s.github.io/cse-stat-416-sp20/), [template](https://valentina-s.github.io/course-website-template/)	 



## Repo Creation
For simplicity we suggest to create a separate repo for the webpage (separate from the code). We will also provide the option to set it up for the repo that you already have, but that will require more git work. If needed ownership and website name can be changed in the future, so pick something as a starting point. 

### Option 1 (new repo)
* decide on a name for the repository: we suggest to follow the format `DSSGYEAR-name-of-repo` (it will determine the webpage url)
* provide an eScience Data Scientist with the name and the usernames of all the team members
* we will create a repo under the [uwescience organization](https://github.com/uwescience) for you and the final address will be [uwescience.github.io/DSSGYEAR-name-of-repo](uwescience.github.io/DSSGYEAR-name-of-repo) (select `uwescience/DSSG-website-template` as a Repository Template)
* enable publishing through the main branch (Settings -> Pages in the left panel)
* add a link on the right for quick access to the webpage (pay attention to how the url is created)

### Option 2 (existing repo)

 * create a gh-pages branch (make it orphan so that it does not have any history)
 * remove all tracked files from it
 * pull the files from the template
 * push to github the changes to create a public gh-pages branch
 * enable publishing through the gh-pages branch (Settings -> GitHub-Pages)
 
 ```
    # make an orphan branch
    git checkout --orphan gh-pages
    
    # preview files to be deleted
    git rm -rf --dry-run .
    
    # actually delete the files
    git rm -rf .
    
    # get the template
    git pull https://github.com/uwescience/DSSG-website-template
    
    # push the local branch to a public branch on github
    git push origin gh-pages 
 ```


## Configuring your website
* Modify your project name in the `_config.yml` file
	
## Editing your webpage

* Each page is a markdown document
	* Markdown is a text marking language designed for the web 
		* [Markdown Tutorial](https://daringfireball.net/projects/markdown/syntax)
	
	* You can modify the markdown documents from the website (hit the edit button and commit when finished)
    	* You can also clone the repo (or your fork of it) and make modifications locally
		* [Macdown Editor for Mac](https://macdown.uranusjr.com/)
		* [MarkdownPad for Windows](http://markdownpad.com/news/2013/introducing-markdownpad-2/)
		* [Visual Studio Code](https://code.visualstudio.com/docs/languages/markdown)
		
* If you want to preview the webpage locally you need to install [Jekyll](https://jekyllrb.com/docs/installation/)(it is a bit involved), then run
`bundle exec jekyll serve`
	
* You can modify your pages by setting up the sidebar:

	* [https://github.com/uwescience/DSSG-website-template/blob/master/_includes/sidebar.html](https://github.com/uwescience/DSSG-website-template/blob/master/_includes/sidebar.html)


* Images go into [assets/img](https://github.com/uwescience/DSSG-website-template/tree/master/assets/img)
	* they can be accessed by:
			```
			<img src="{{ site.url }}{{ site.baseurl }}/assets/img/eScience.png">
			```
	* to upload images through the website you need to have push access (otherwise do it locally and submit a pull request)
	
	* feel free to have a different header image relevant to your project

* Some colors and fonts are set in the [`.css file`](https://github.com/uwescience/DSSG-website-template/blob/master/public/css/hyde.css)
	
* The theme that we are using is called [Hyde](https://github.com/poole/hyde): you can read more details about it below. Feel free to use a different theme ([gh-pages themes](https://pages.github.com/themes/), [Jekyll themes](https://jekyllthemes.io/)), but you will have to figure out how to change it on your own. There are some options to make some of the content executable using the [JupyterBook](https://jupyterbook.org/intro.html) template. [Minima](https://jekyll.github.io/minima/about/) is another very simplistic theme which can include a blog and be adapted as you wish.

* If you do not want to rush, make your writings visible on the website, you can work in a fork, or simply work on a markdown file which you can share with your teammates for review (check out [https://hackmd.io/](https://hackmd.io/) for collaborative markdown editing for up to 4 people)). 




---

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
