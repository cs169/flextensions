// datatables.net-responsive@3.0.4 downloaded from https://ga.jspm.io/npm:datatables.net-responsive@3.0.4/js/dataTables.responsive.mjs

import e from"jquery";import t from"datatables.net";export{default}from"datatables.net";let r=e;
/**
 * Responsive is a plug-in for the DataTables library that makes use of
 * DataTables' ability to change the visibility of columns, changing the
 * visibility of columns so the displayed columns fit into the table container.
 * The end result is that complex tables will be dynamically adjusted to fit
 * into the viewport, be it on a desktop, tablet or mobile browser.
 *
 * Responsive for DataTables has two modes of operation, which can used
 * individually or combined:
 *
 * * Class name based control - columns assigned class names that match the
 *   breakpoint logic can be shown / hidden as required for each breakpoint.
 * * Automatic control - columns are automatically hidden when there is no
 *   room left to display them. Columns removed from the right.
 *
 * In additional to column visibility control, Responsive also has built into
 * options to use DataTables' child row display to show / hide the information
 * from the table that has been hidden. There are also two modes of operation
 * for this child row display:
 *
 * * Inline - when the control element that the user can use to show / hide
 *   child rows is displayed inside the first column of the table.
 * * Column - where a whole column is dedicated to be the show / hide control.
 *
 * Initialisation of Responsive is performed by:
 *
 * * Adding the class `responsive` or `dt-responsive` to the table. In this case
 *   Responsive will automatically be initialised with the default configuration
 *   options when the DataTable is created.
 * * Using the `responsive` option in the DataTables configuration options. This
 *   can also be used to specify the configuration options, or simply set to
 *   `true` to use the defaults.
 *
 *  @class
 *  @param {object} settings DataTables settings object for the host table
 *  @param {object} [opts] Configuration options
 *  @requires jQuery 1.7+
 *  @requires DataTables 2.0.0+
 *
 *  @example
 *      $('#example').DataTable( {
 *        responsive: true
 *      } );
 *    } );
 */var Responsive=function(e,n){if(!t.versionCheck||!t.versionCheck("2"))throw"DataTables Responsive requires DataTables 2 or newer";this.s={childNodeStore:{},columns:[],current:[],dt:new t.Api(e)};if(!this.s.dt.settings()[0].responsive){n&&typeof n.details==="string"?n.details={type:n.details}:n&&n.details===false?n.details={type:false}:n&&n.details===true&&(n.details={type:"inline"});this.c=r.extend(true,{},Responsive.defaults,t.defaults.responsive,n);e.responsive=this;this._constructor()}};r.extend(Responsive.prototype,{_constructor:function(){var e=this;var n=this.s.dt;var i=r(window).innerWidth();n.settings()[0]._responsive=this;r(window).on("orientationchange.dtr",t.util.throttle((function(){var t=r(window).innerWidth();if(t!==i){e._resize();i=t}})));n.on("row-created.dtr",(function(t,i,s,a){r.inArray(false,e.s.current)!==-1&&r(">td, >th",i).each((function(t){var i=n.column.index("toData",t);e.s.current[i]===false&&r(this).css("display","none").addClass("dtr-hidden")}))}));n.on("destroy.dtr",(function(){n.off(".dtr");r(n.table().body()).off(".dtr");r(window).off("resize.dtr orientationchange.dtr");n.cells(".dtr-control").nodes().to$().removeClass("dtr-control");r(n.table().node()).removeClass("dtr-inline collapsed");r.each(e.s.current,(function(t,r){r===false&&e._setColumnVis(t,true)}))}));this.c.breakpoints.sort((function(e,t){return e.width<t.width?1:e.width>t.width?-1:0}));this._classLogic();var s=this.c.details;if(s.type!==false){e._detailsInit();n.on("column-visibility.dtr",(function(){e._timer&&clearTimeout(e._timer);e._timer=setTimeout((function(){e._timer=null;e._classLogic();e._resizeAuto();e._resize(true);e._redrawChildren()}),100)}));n.on("draw.dtr",(function(){e._redrawChildren()}));r(n.table().node()).addClass("dtr-"+s.type)}n.on("column-calc.dt",(function(t,r){var n=e.s.current;for(var i=0;i<n.length;i++){var s=r.visible.indexOf(i);n[i]===false&&s>=0&&r.visible.splice(s,1)}}));n.on("preXhr.dtr",(function(){var t=[];n.rows().every((function(){this.child.isShown()&&t.push(this.id(true))}));n.one("draw.dtr",(function(){e._resizeAuto();e._resize();n.rows(t).every((function(){e._detailsDisplay(this,false)}))}))}));n.on("draw.dtr",(function(){e._controlClass()})).ready((function(){e._resizeAuto();e._resize();n.on("column-reorder.dtr",(function(t,r,n){e._classLogic();e._resizeAuto();e._resize(true)}));n.on("column-sizing.dtr",(function(){e._resizeAuto();e._resize()}))}))},
/**
	 * Insert a `col` tag into the correct location in a `colgroup`.
	 *
	 * @param {jQuery} colGroup The `colgroup` tag
	 * @param {jQuery} colEl The `col` tag
	 */
_colGroupAttach:function(e,t,r){var n=null;if(t[r].get(0).parentNode!==e[0]){for(var i=r+1;i<t.length;i++)if(e[0]===t[i].get(0).parentNode){n=i;break}n!==null?t[r].insertBefore(t[n][0]):e.append(t[r])}},
/**
	 * Get and store nodes from a cell - use for node moving renderers
	 *
	 * @param {*} dt DT instance
	 * @param {*} row Row index
	 * @param {*} col Column index
	 */
_childNodes:function(e,t,r){var n=t+"-"+r;if(this.s.childNodeStore[n])return this.s.childNodeStore[n];var i=[];var s=e.cell(t,r).node().childNodes;for(var a=0,o=s.length;a<o;a++)i.push(s[a]);this.s.childNodeStore[n]=i;return i},
/**
	 * Restore nodes from the cache to a table cell
	 *
	 * @param {*} dt DT instance
	 * @param {*} row Row index
	 * @param {*} col Column index
	 */
_childNodesRestore:function(e,t,r){var n=t+"-"+r;if(this.s.childNodeStore[n]){var i=e.cell(t,r).node();var s=this.s.childNodeStore[n];if(s.length>0){var a=s[0].parentNode;var o=a.childNodes;var d=[];for(var l=0,c=o.length;l<c;l++)d.push(o[l]);for(var u=0,f=d.length;u<f;u++)i.appendChild(d[u])}this.s.childNodeStore[n]=void 0}},
/**
	 * Calculate the visibility for the columns in a table for a given
	 * breakpoint. The result is pre-determined based on the class logic if
	 * class names are used to control all columns, but the width of the table
	 * is also used if there are columns which are to be automatically shown
	 * and hidden.
	 *
	 * @param  {string} breakpoint Breakpoint name to use for the calculation
	 * @return {array} Array of boolean values initiating the visibility of each
	 *   column.
	 *  @private
	 */
_columnsVisiblity:function(e){var t=this.s.dt;var n=this.s.columns;var i,s;var a=n.map((function(e,t){return{columnIdx:t,priority:e.priority}})).sort((function(e,t){return e.priority!==t.priority?e.priority-t.priority:e.columnIdx-t.columnIdx}));var o=r.map(n,(function(n,i){return t.column(i).visible()===false?"not-visible":(!n.auto||n.minWidth!==null)&&(n.auto===true?"-":r.inArray(e,n.includeIn)!==-1)}));var d=0;for(i=0,s=o.length;i<s;i++)o[i]===true&&(d+=n[i].minWidth);var l=t.settings()[0].oScroll;var c=l.sY||l.sX?l.iBarWidth:0;var u=t.table().container().offsetWidth-c;var f=u-d;for(i=0,s=o.length;i<s;i++)n[i].control&&(f-=n[i].minWidth);var h=false;for(i=0,s=a.length;i<s;i++){var v=a[i].columnIdx;if(o[v]==="-"&&!n[v].control&&n[v].minWidth){if(h||f-n[v].minWidth<0){h=true;o[v]=false}else o[v]=true;f-=n[v].minWidth}}var p=false;for(i=0,s=n.length;i<s;i++)if(!n[i].control&&!n[i].never&&o[i]===false){p=true;break}for(i=0,s=n.length;i<s;i++){n[i].control&&(o[i]=p);o[i]==="not-visible"&&(o[i]=false)}r.inArray(true,o)===-1&&(o[0]=true);return o},_classLogic:function(){var e=this;var t=this.c.breakpoints;var n=this.s.dt;var i=n.columns().eq(0).map((function(e){var t=this.column(e);var r=t.header().className;var n=t.init().responsivePriority;var i=t.header().getAttribute("data-priority");n===void 0&&(n=i===void 0||i===null?1e4:i*1);return{className:r,includeIn:[],auto:false,control:false,never:!!r.match(/\b(dtr\-)?never\b/),priority:n}}));var add=function(e,t){var n=i[e].includeIn;r.inArray(t,n)===-1&&n.push(t)};var column=function(r,n,s,a){var o,d,l;if(s){if(s==="max-"){o=e._find(n).width;for(d=0,l=t.length;d<l;d++)t[d].width<=o&&add(r,t[d].name)}else if(s==="min-"){o=e._find(n).width;for(d=0,l=t.length;d<l;d++)t[d].width>=o&&add(r,t[d].name)}else if(s==="not-")for(d=0,l=t.length;d<l;d++)t[d].name.indexOf(a)===-1&&add(r,t[d].name)}else i[r].includeIn.push(n)};i.each((function(e,n){var i=e.className.split(" ");var s=false;for(var a=0,o=i.length;a<o;a++){var d=i[a].trim();if(d==="all"||d==="dtr-all"){s=true;e.includeIn=r.map(t,(function(e){return e.name}));return}if(d==="none"||d==="dtr-none"||e.never){s=true;return}if(d==="control"||d==="dtr-control"){s=true;e.control=true;return}r.each(t,(function(e,t){var r=t.name.split("-");var i=new RegExp("(min\\-|max\\-|not\\-)?("+r[0]+")(\\-[_a-zA-Z0-9])?");var a=d.match(i);if(a){s=true;a[2]===r[0]&&a[3]==="-"+r[1]?column(n,t.name,a[1],a[2]+a[3]):a[2]!==r[0]||a[3]||column(n,t.name,a[1],a[2])}}))}s||(e.auto=true)}));this.s.columns=i},_controlClass:function(){if(this.c.details.type==="inline"){var e=this.s.dt;var t=this.s.current;var n=r.inArray(true,t);e.cells(null,(function(e){return e!==n}),{page:"current"}).nodes().to$().filter(".dtr-control").removeClass("dtr-control");n>=0&&e.cells(null,n,{page:"current"}).nodes().to$().addClass("dtr-control")}this._tabIndexes()},
/**
	 * Show the details for the child row
	 *
	 * @param  {DataTables.Api} row    API instance for the row
	 * @param  {boolean}        update Update flag
	 * @private
	 */
_detailsDisplay:function(e,t){var n=this;var i=this.s.dt;var s=this.c.details;var event=function(n){r(e.node()).toggleClass("dtr-expanded",n!==false);r(i.table().node()).triggerHandler("responsive-display.dt",[i,e,n,t])};if(s&&s.type!==false){var a=typeof s.renderer==="string"?Responsive.renderer[s.renderer]():s.renderer;var o=s.display(e,t,(function(){return a.call(n,i,e[0][0],n._detailsObj(e[0]))}),(function(){event(false)}));typeof o==="boolean"&&event(o)}},_detailsInit:function(){var e=this;var t=this.s.dt;var n=this.c.details;n.type==="inline"&&(n.target="td.dtr-control, th.dtr-control");r(t.table().body()).on("keyup.dtr","td, th",(function(e){e.keyCode===13&&r(this).data("dtr-keyboard")&&r(this).click()}));var i=n.target;var s=typeof i==="string"?i:"td, th";i===void 0&&i===null||r(t.table().body()).on("click.dtr mousedown.dtr mouseup.dtr",s,(function(n){if(r(t.table().node()).hasClass("collapsed")&&r.inArray(r(this).closest("tr").get(0),t.rows().nodes().toArray())!==-1){if(typeof i==="number"){var s=i<0?t.columns().eq(0).length+i:i;if(t.cell(this).index().column!==s)return}var a=t.row(r(this).closest("tr"));n.type==="click"?e._detailsDisplay(a,false):n.type==="mousedown"?r(this).css("outline","none"):n.type==="mouseup"&&r(this).trigger("blur").css("outline","")}}))},
/**
	 * Get the details to pass to a renderer for a row
	 * @param  {int} rowIdx Row index
	 * @private
	 */
_detailsObj:function(e){var t=this;var n=this.s.dt;return r.map(this.s.columns,(function(r,i){if(!r.never&&!r.control){var s=n.settings()[0].aoColumns[i];return{className:s.sClass,columnIndex:i,data:n.cell(e,i).render(t.c.orthogonal),hidden:n.column(i).visible()&&!t.s.current[i],rowIndex:e,title:n.column(i).title()}}}))},
/**
	 * Find a breakpoint object from a name
	 *
	 * @param  {string} name Breakpoint name to find
	 * @return {object}      Breakpoint description object
	 * @private
	 */
_find:function(e){var t=this.c.breakpoints;for(var r=0,n=t.length;r<n;r++)if(t[r].name===e)return t[r]},_redrawChildren:function(){var e=this;var t=this.s.dt;t.rows({page:"current"}).iterator("row",(function(r,n){e._detailsDisplay(t.row(n),true)}))},
/**
	 * Alter the table display for a resized viewport. This involves first
	 * determining what breakpoint the window currently is in, getting the
	 * column visibilities to apply and then setting them.
	 *
	 * @param  {boolean} forceRedraw Force a redraw
	 * @private
	 */
_resize:function(e){var t=this;var n=this.s.dt;var i=r(window).innerWidth();var s=this.c.breakpoints;var a=s[0].name;var o=this.s.columns;var d,l;var c=this.s.current.slice();for(d=s.length-1;d>=0;d--)if(i<=s[d].width){a=s[d].name;break}var u=this._columnsVisiblity(a);this.s.current=u;var f=false;for(d=0,l=o.length;d<l;d++)if(u[d]===false&&!o[d].never&&!o[d].control&&!n.column(d).visible()===false){f=true;break}r(n.table().node()).toggleClass("collapsed",f);var h=false;var v=0;var p=n.settings()[0];var m=r(n.table().node()).children("colgroup");var b=p.aoColumns.map((function(e){return e.colEl}));n.columns().eq(0).each((function(r,i){if(n.column(r).visible()){u[i]===true&&v++;if(e||u[i]!==c[i]){h=true;t._setColumnVis(r,u[i])}u[i]?t._colGroupAttach(m,b,i):b[i].detach()}}));if(h){n.columns.adjust();this._redrawChildren();r(n.table().node()).trigger("responsive-resize.dt",[n,this._responsiveOnlyHidden()]);n.page.info().recordsDisplay===0&&r("td",n.table().body()).eq(0).attr("colspan",v)}t._controlClass()},_resizeAuto:function(){var e=this.s.dt;var t=this.s.columns;var n=this;var i=e.columns().indexes().filter((function(t){return e.column(t).visible()}));if(this.c.auto&&r.inArray(true,r.map(t,(function(e){return e.auto})))!==-1){var s=e.table().node().cloneNode(false);var a=r(e.table().header().cloneNode(false)).appendTo(s);var o=r(e.table().footer().cloneNode(false)).appendTo(s);var d=r(e.table().body()).clone(false,false).empty().appendTo(s);s.style.width="auto";e.table().header.structure(i).forEach((e=>{var t=e.filter((function(e){return!!e})).map((function(e){return r(e.cell).clone(false).css("display","table-cell").css("width","auto").css("min-width",0)}));r("<tr/>").append(t).appendTo(a)}));var l=r("<tr/>").appendTo(d);for(var c=0;c<i.count();c++)l.append("<td/>");this.c.details.renderer._responsiveMovesNodes?e.rows({page:"current"}).every((function(t){var s=this.node();if(s){var a=s.cloneNode(false);e.cells(t,i).every((function(e,i){var s=n.s.childNodeStore[t+"-"+i];s?r(this.node().cloneNode(false)).append(r(s).clone()).appendTo(a):r(this.node()).clone(false).appendTo(a)}));d.append(a)}})):r(d).append(r(e.rows({page:"current"}).nodes()).clone(false)).find("th, td").css("display","");d.find("th, td").css("display","");e.table().footer.structure(i).forEach((e=>{var t=e.filter((function(e){return!!e})).map((function(e){return r(e.cell).clone(false).css("display","table-cell").css("width","auto").css("min-width",0)}));r("<tr/>").append(t).appendTo(o)}));this.c.details.type==="inline"&&r(s).addClass("dtr-inline collapsed");r(s).find("[name]").removeAttr("name");r(s).css("position","relative");var u=r("<div/>").css({width:1,height:1,overflow:"hidden",clear:"both"}).append(s);u.insertBefore(e.table().node());l.children().each((function(r){var n=e.column.index("fromVisible",r);t[n].minWidth=this.offsetWidth||0}));u.remove()}},_responsiveOnlyHidden:function(){var e=this.s.dt;return r.map(this.s.current,(function(t,r){return e.column(r).visible()===false||t}))},
/**
	 * Set a column's visibility.
	 *
	 * We don't use DataTables' column visibility controls in order to ensure
	 * that column visibility can Responsive can no-exist. Since only IE8+ is
	 * supported (and all evergreen browsers of course) the control of the
	 * display attribute works well.
	 *
	 * @param {integer} col      Column index
	 * @param {boolean} showHide Show or hide (true or false)
	 * @private
	 */
_setColumnVis:function(e,t){var n=this;var i=this.s.dt;var s=t?"":"none";this._setHeaderVis(e,t,i.table().header.structure());this._setHeaderVis(e,t,i.table().footer.structure());i.column(e).nodes().to$().css("display",s).toggleClass("dtr-hidden",!t);r.isEmptyObject(this.s.childNodeStore)||i.cells(null,e).indexes().each((function(e){n._childNodesRestore(i,e.row,e.column)}))},
/**
	 * Set the a column's visibility, taking into account multiple rows
	 * in a header / footer and colspan attributes
	 * @param {*} col
	 * @param {*} showHide
	 * @param {*} structure
	 */
_setHeaderVis:function(e,t,n){var i=this;var s=t?"":"none";n.forEach((function(e,t){for(var r=0;r<e.length;r++)if(e[r]&&e[r].rowspan>1){var i=e[r].rowspan;for(var s=1;s<i;s++)n[t+s][r]={}}}));n.forEach((function(n){if(n[e]&&n[e].cell)r(n[e].cell).css("display",s).toggleClass("dtr-hidden",!t);else{var a=e;while(a>=0){if(n[a]&&n[a].cell){n[a].cell.colSpan=i._colspan(n,a);break}a--}}}))},
/**
	 * How many columns should this cell span
	 *
	 * @param {*} row Header structure row
	 * @param {*} idx The column index of the cell to span
	 */
_colspan:function(e,t){var r=1;for(var n=t+1;n<e.length;n++)if(e[n]===null&&this.s.current[n])r++;else if(e[n])break;return r},_tabIndexes:function(){var e=this.s.dt;var t=e.cells({page:"current"}).nodes().to$();var n=e.settings()[0];var i=this.c.details.target;t.filter("[data-dtr-keyboard]").removeData("[data-dtr-keyboard]");if(typeof i==="number")e.cells(null,i,{page:"current"}).nodes().to$().attr("tabIndex",n.iTabIndex).data("dtr-keyboard",1);else{i==="td:first-child, th:first-child"&&(i=">td:first-child, >th:first-child");var s=e.rows({page:"current"}).nodes();var a=i==="tr"?r(s):r(i,s);a.attr("tabIndex",n.iTabIndex).data("dtr-keyboard",1)}}});Responsive.breakpoints=[{name:"desktop",width:Infinity},{name:"tablet-l",width:1024},{name:"tablet-p",width:768},{name:"mobile-l",width:480},{name:"mobile-p",width:320}];Responsive.display={childRow:function(e,t,n){var i=r(e.node());if(!t){if(i.hasClass("dtr-expanded")){e.child(false);return false}var s=n();if(s===false)return false;e.child(s,"child").show();return true}if(i.hasClass("dtr-expanded")){e.child(n(),"child").show();return true}},childRowImmediate:function(e,t,n){var i=r(e.node());if(!t&&i.hasClass("dtr-expanded")||!e.responsive.hasHidden()){e.child(false);return false}var s=n();if(s===false)return false;e.child(s,"child").show();return true},modal:function(e){return function(t,n,i,s){var a;var o=i();if(o===false)return false;if(n){a=r("div.dtr-modal-content");if(!a.length||t.index()!==a.data("dtr-row-idx"))return null;a.empty().append(o)}else{var close=function(){a.remove();r(document).off("keypress.dtr");r(t.node()).removeClass("dtr-expanded");s()};a=r('<div class="dtr-modal"/>').append(r('<div class="dtr-modal-display"/>').append(r('<div class="dtr-modal-content"/>').data("dtr-row-idx",t.index()).append(o)).append(r('<div class="dtr-modal-close">&times;</div>').click((function(){close()})))).append(r('<div class="dtr-modal-background"/>').click((function(){close()}))).appendTo("body");r(t.node()).addClass("dtr-expanded");r(document).on("keyup.dtr",(function(e){if(e.keyCode===27){e.stopPropagation();close()}}))}e&&e.header&&r("div.dtr-modal-content").prepend("<h2>"+e.header(t)+"</h2>");return true}}};Responsive.renderer={listHiddenNodes:function(){var fn=function(e,t,n){var i=this;var s=r('<ul data-dtr-index="'+t+'" class="dtr-details"/>');var a=false;r.each(n,(function(t,n){if(n.hidden){var o=n.className?'class="'+n.className+'"':"";r("<li "+o+' data-dtr-index="'+n.columnIndex+'" data-dt-row="'+n.rowIndex+'" data-dt-column="'+n.columnIndex+'"><span class="dtr-title">'+n.title+"</span> </li>").append(r('<span class="dtr-data"/>').append(i._childNodes(e,n.rowIndex,n.columnIndex))).appendTo(s);a=true}}));return!!a&&s};fn._responsiveMovesNodes=true;return fn},listHidden:function(){return function(e,t,n){var i=r.map(n,(function(e){var t=e.className?'class="'+e.className+'"':"";return e.hidden?"<li "+t+' data-dtr-index="'+e.columnIndex+'" data-dt-row="'+e.rowIndex+'" data-dt-column="'+e.columnIndex+'"><span class="dtr-title">'+e.title+'</span> <span class="dtr-data">'+e.data+"</span></li>":""})).join("");return!!i&&r('<ul data-dtr-index="'+t+'" class="dtr-details"/>').append(i)}},tableAll:function(e){e=r.extend({tableClass:""},e);return function(t,n,i){var s=r.map(i,(function(e){var t=e.className?'class="'+e.className+'"':"";return"<tr "+t+' data-dt-row="'+e.rowIndex+'" data-dt-column="'+e.columnIndex+'"><td>'+(""!==e.title?e.title+":":"")+"</td> <td>"+e.data+"</td></tr>"})).join("");return r('<table class="'+e.tableClass+' dtr-details" width="100%"/>').append(s)}}};Responsive.defaults={
/**
	 * List of breakpoints for the instance. Note that this means that each
	 * instance can have its own breakpoints. Additionally, the breakpoints
	 * cannot be changed once an instance has been creased.
	 *
	 * @type {Array}
	 * @default Takes the value of `Responsive.breakpoints`
	 */
breakpoints:Responsive.breakpoints,
/**
	 * Enable / disable auto hiding calculations. It can help to increase
	 * performance slightly if you disable this option, but all columns would
	 * need to have breakpoint classes assigned to them
	 *
	 * @type {Boolean}
	 * @default  `true`
	 */
auto:true,
/**
	 * Details control. If given as a string value, the `type` property of the
	 * default object is set to that value, and the defaults used for the rest
	 * of the object - this is for ease of implementation.
	 *
	 * The object consists of the following properties:
	 *
	 * * `display` - A function that is used to show and hide the hidden details
	 * * `renderer` - function that is called for display of the child row data.
	 *   The default function will show the data from the hidden columns
	 * * `target` - Used as the selector for what objects to attach the child
	 *   open / close to
	 * * `type` - `false` to disable the details display, `inline` or `column`
	 *   for the two control types
	 *
	 * @type {Object|string}
	 */
details:{display:Responsive.display.childRow,renderer:Responsive.renderer.listHidden(),target:0,type:"inline"},
/**
	 * Orthogonal data request option. This is used to define the data type
	 * requested when Responsive gets the data to show in the child row.
	 *
	 * @type {String}
	 */
orthogonal:"display"};var n=r.fn.dataTable.Api;n.register("responsive()",(function(){return this}));n.register("responsive.index()",(function(e){e=r(e);return{column:e.data("dtr-index"),row:e.parent().data("dtr-index")}}));n.register("responsive.rebuild()",(function(){return this.iterator("table",(function(e){e._responsive&&e._responsive._classLogic()}))}));n.register("responsive.recalc()",(function(){return this.iterator("table",(function(e){if(e._responsive){e._responsive._resizeAuto();e._responsive._resize()}}))}));n.register("responsive.hasHidden()",(function(){var e=this.context[0];return!!e._responsive&&r.inArray(false,e._responsive._responsiveOnlyHidden())!==-1}));n.registerPlural("columns().responsiveHidden()","column().responsiveHidden()",(function(){return this.iterator("column",(function(e,t){return!!e._responsive&&e._responsive._responsiveOnlyHidden()[t]}),1)}));Responsive.version="3.0.4";r.fn.dataTable.Responsive=Responsive;r.fn.DataTable.Responsive=Responsive;r(document).on("preInit.dt.dtr",(function(e,n,i){if(e.namespace==="dt"&&(r(n.nTable).hasClass("responsive")||r(n.nTable).hasClass("dt-responsive")||n.oInit.responsive||t.defaults.responsive)){var s=n.oInit.responsive;s!==false&&new Responsive(n,r.isPlainObject(s)?s:{})}}));

