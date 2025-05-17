// datatables.net-buttons@3.2.3 downloaded from https://ga.jspm.io/npm:datatables.net-buttons@3.2.3/js/dataTables.buttons.mjs

import t from"jquery";import e from"datatables.net";export{default}from"datatables.net";let n=t;var o=0;var i=0;var r=e.ext.buttons;var a=null;function _fadeIn(t,e,o){if(n.fn.animate)t.stop().fadeIn(e,o);else{t.css("display","block");o&&o.call(t)}}function _fadeOut(t,e,o){if(n.fn.animate)t.stop().fadeOut(e,o);else{t.css("display","none");o&&o.call(t)}}
/**
 * [Buttons description]
 * @param {[type]}
 * @param {[type]}
 */var Buttons=function(t,i){if(!e.versionCheck("2"))throw"Warning: Buttons requires DataTables 2 or newer";if(!(this instanceof Buttons))return function(e){return new Buttons(e,t).container()};typeof i==="undefined"&&(i={});i===true&&(i={});Array.isArray(i)&&(i={buttons:i});this.c=n.extend(true,{},Buttons.defaults,i);i.buttons&&(this.c.buttons=i.buttons);this.s={dt:new e.Api(t),buttons:[],listenKeys:"",namespace:"dtb"+o++};this.dom={container:n("<"+this.c.dom.container.tag+"/>").addClass(this.c.dom.container.className)};this._constructor()};n.extend(Buttons.prototype,{
/**
	 * Get the action of a button
	 * @param  {int|string} Button index
	 * @return {function}
	 */
/**
	 * Set the action of a button
	 * @param  {node} node Button element
	 * @param  {function} action Function to set
	 * @return {Buttons} Self for chaining
	 */
action:function(t,e){var n=this._nodeToButton(t);if(e===void 0)return n.conf.action;n.conf.action=e;return this},
/**
	 * Add an active class to the button to make to look active or get current
	 * active state.
	 * @param  {node} node Button element
	 * @param  {boolean} [flag] Enable / disable flag
	 * @return {Buttons} Self for chaining or boolean for getter
	 */
active:function(t,e){var o=this._nodeToButton(t);var i=this.c.dom.button.active;var r=n(o.node);o.inCollection&&this.c.dom.collection.button&&this.c.dom.collection.button.active!==void 0&&(i=this.c.dom.collection.button.active);if(e===void 0)return r.hasClass(i);r.toggleClass(i,e===void 0||e);return this},
/**
	 * Add a new button
	 * @param {object} config Button configuration object, base string name or function
	 * @param {int|string} [idx] Button index for where to insert the button
	 * @param {boolean} [draw=true] Trigger a draw. Set a false when adding
	 *   lots of buttons, until the last button.
	 * @return {Buttons} Self for chaining
	 */
add:function(t,e,n){var o=this.s.buttons;if(typeof e==="string"){var i=e.split("-");var r=this.s;for(var a=0,s=i.length-1;a<s;a++)r=r.buttons[i[a]*1];o=r.buttons;e=i[i.length-1]*1}this._expandButton(o,t,t!==void 0?t.split:void 0,(t===void 0||t.split===void 0||t.split.length===0)&&r!==void 0,false,e);n!==void 0&&n!==true||this._draw();return this},collectionRebuild:function(t,e){var n=this._nodeToButton(t);if(e!==void 0){var o;for(o=n.buttons.length-1;o>=0;o--)this.remove(n.buttons[o].node);n.conf.prefixButtons&&e.unshift.apply(e,n.conf.prefixButtons);n.conf.postfixButtons&&e.push.apply(e,n.conf.postfixButtons);for(o=0;o<e.length;o++){var i=e[o];this._expandButton(n.buttons,i,i!==void 0&&i.config!==void 0&&i.config.split!==void 0,true,i.parentConf!==void 0&&i.parentConf.split!==void 0,null,i.parentConf)}}this._draw(n.collection,n.buttons)},container:function(){return this.dom.container},
/**
	 * Disable a button
	 * @param  {node} node Button node
	 * @return {Buttons} Self for chaining
	 */
disable:function(t){var e=this._nodeToButton(t);e.isSplit?n(e.node.childNodes[0]).addClass(this.c.dom.button.disabled).prop("disabled",true):n(e.node).addClass(this.c.dom.button.disabled).prop("disabled",true);e.disabled=true;this._checkSplitEnable();return this},destroy:function(){n("body").off("keyup."+this.s.namespace);var t=this.s.buttons.slice();var e,o;for(e=0,o=t.length;e<o;e++)this.remove(t[e].node);this.dom.container.remove();var i=this.s.dt.settings()[0];for(e=0,o=i.length;e<o;e++)if(i.inst===this){i.splice(e,1);break}return this},
/**
	 * Enable / disable a button
	 * @param  {node} node Button node
	 * @param  {boolean} [flag=true] Enable / disable flag
	 * @return {Buttons} Self for chaining
	 */
enable:function(t,e){if(e===false)return this.disable(t);var o=this._nodeToButton(t);o.isSplit?n(o.node.childNodes[0]).removeClass(this.c.dom.button.disabled).prop("disabled",false):n(o.node).removeClass(this.c.dom.button.disabled).prop("disabled",false);o.disabled=false;this._checkSplitEnable();return this},
/**
	 * Get a button's index
	 *
	 * This is internally recursive
	 * @param {element} node Button to get the index of
	 * @return {string} Button index
	 */
index:function(t,e,n){if(!e){e="";n=this.s.buttons}for(var o=0,i=n.length;o<i;o++){var r=n[o].buttons;if(n[o].node===t)return e+o;if(r&&r.length){var a=this.index(t,o+"-",r);if(a!==null)return a}}return null},name:function(){return this.c.name},
/**
	 * Get a button's node of the buttons container if no button is given
	 * @param  {node} [node] Button node
	 * @return {jQuery} Button element, or container
	 */
node:function(t){if(!t)return this.dom.container;var e=this._nodeToButton(t);return n(e.node)},
/**
	 * Set / get a processing class on the selected button
	 * @param {element} node Triggering button node
	 * @param  {boolean} flag true to add, false to remove, undefined to get
	 * @return {boolean|Buttons} Getter value or this if a setter.
	 */
processing:function(t,e){var o=this.s.dt;var i=this._nodeToButton(t);if(e===void 0)return n(i.node).hasClass("processing");n(i.node).toggleClass("processing",e);n(o.table().node()).triggerHandler("buttons-processing.dt",[e,o.button(t),o,n(t),i.conf]);return this},
/**
	 * Remove a button.
	 * @param  {node} node Button node
	 * @return {Buttons} Self for chaining
	 */
remove:function(t){var e=this._nodeToButton(t);var o=this._nodeToHost(t);var i=this.s.dt;if(e.buttons.length)for(var r=e.buttons.length-1;r>=0;r--)this.remove(e.buttons[r].node);e.conf.destroying=true;e.conf.destroy&&e.conf.destroy.call(i.button(t),i,n(t),e.conf);this._removeKey(e.conf);n(e.node).remove();e.inserter&&n(e.inserter).remove();var a=n.inArray(e,o);o.splice(a,1);return this},
/**
	 * Get the text for a button
	 * @param  {int|string} node Button index
	 * @return {string} Button text
	 */
/**
	 * Set the text for a button
	 * @param  {int|string|function} node Button index
	 * @param  {string} label Text
	 * @return {Buttons} Self for chaining
	 */
text:function(t,e){var o=this._nodeToButton(t);var i=o.textNode;var r=this.s.dt;var a=n(o.node);var text=function(t){return typeof t==="function"?t(r,a,o.conf):t};if(e===void 0)return text(o.conf.text);o.conf.text=e;i.html(text(e));return this},_constructor:function(){var t=this;var e=this.s.dt;var o=e.settings()[0];var i=this.c.buttons;o._buttons||(o._buttons=[]);o._buttons.push({inst:this,name:this.c.name});for(var r=0,a=i.length;r<a;r++)this.add(i[r]);e.on("destroy",(function(e,n){n===o&&t.destroy()}));n("body").on("keyup."+this.s.namespace,(function(e){if(!document.activeElement||document.activeElement===document.body){var n=String.fromCharCode(e.keyCode).toLowerCase();t.s.listenKeys.toLowerCase().indexOf(n)!==-1&&t._keypress(n,e)}}))},
/**
	 * Add a new button to the key press listener
	 * @param {object} conf Resolved button configuration object
	 * @private
	 */
_addKey:function(t){t.key&&(this.s.listenKeys+=n.isPlainObject(t.key)?t.key.key:t.key)},
/**
	 * Insert the buttons into the container. Call without parameters!
	 * @param  {node} [container] Recursive only - Insert point
	 * @param  {array} [buttons] Recursive only - Buttons array
	 * @private
	 */
_draw:function(t,e){if(!t){t=this.dom.container;e=this.s.buttons}t.children().detach();for(var n=0,o=e.length;n<o;n++){t.append(e[n].inserter);t.append(" ");e[n].buttons&&e[n].buttons.length&&this._draw(e[n].collection,e[n].buttons)}},
/**
	 * Create buttons from an array of buttons
	 * @param  {array} attachTo Buttons array to attach to
	 * @param  {object} button Button definition
	 * @param  {boolean} inCollection true if the button is in a collection
	 * @private
	 */
_expandButton:function(t,e,o,i,r,a,s){var l=this.s.dt;var u=false;var c=this.c.dom.collection;var d=Array.isArray(e)?e:[e];e===void 0&&(d=Array.isArray(o)?o:[o]);for(var f=0,p=d.length;f<p;f++){var h=this._resolveExtends(d[f]);if(h){u=!(!h.config||!h.config.split);if(Array.isArray(h))this._expandButton(t,h,b!==void 0&&b.conf!==void 0?b.conf.split:void 0,i,s!==void 0&&s.split!==void 0,a,s);else{var b=this._buildButton(h,i,h.split!==void 0||h.config!==void 0&&h.config.split!==void 0,r);if(b){if(a!==void 0&&a!==null){t.splice(a,0,b);a++}else t.push(b);b.conf.dropIcon&&!b.conf.split&&n(b.node).addClass(this.c.dom.button.dropClass).append(this.c.dom.button.dropHtml);if(b.conf.buttons){b.collection=n("<"+c.container.content.tag+"/>");b.conf._collection=b.collection;this._expandButton(b.buttons,b.conf.buttons,b.conf.split,!u,u,a,b.conf)}if(b.conf.split){b.collection=n("<"+c.container.tag+"/>");b.conf._collection=b.collection;for(var v=0;v<b.conf.split.length;v++){var g=b.conf.split[v];if(typeof g==="object"){g.parent=s;g.collectionLayout===void 0&&(g.collectionLayout=b.conf.collectionLayout);g.dropup===void 0&&(g.dropup=b.conf.dropup);g.fade===void 0&&(g.fade=b.conf.fade)}}this._expandButton(b.buttons,b.conf.buttons,b.conf.split,!u,u,a,b.conf)}b.conf.parent=s;h.init&&h.init.call(l.button(b.node),l,n(b.node),h)}}}}},
/**
	 * Create an individual button
	 * @param  {object} config            Resolved button configuration
	 * @param  {boolean} inCollection `true` if a collection button
	 * @return {object} Completed button description object
	 * @private
	 */
_buildButton:function(t,e,o,a){var s=this;var l=this.c.dom;var u;var c=this.s.dt;var text=function(e){return typeof e==="function"?e(c,p,t):e};var d=n.extend(true,{},l.button);e&&o&&l.collection.split?n.extend(true,d,l.collection.split.action):a||e?n.extend(true,d,l.collection.button):o&&n.extend(true,d,l.split.button);if(t.spacer){var f=n("<"+d.spacer.tag+"/>").addClass("dt-button-spacer "+t.style+" "+d.spacer.className).html(text(t.text));return{conf:t,node:f,nodeChild:null,inserter:f,buttons:[],inCollection:e,isSplit:o,collection:null,textNode:f}}if(t.available&&!t.available(c,t)&&!t.html)return false;var p;if(t.html)p=n(t.html);else{var run=function(t,e,o,i,r){i.action.call(e.button(o),t,e,o,i,r);n(e.table().node()).triggerHandler("buttons-action.dt",[e.button(o),e,o,i])};var action=function(t,e,n,o){if(o.async){s.processing(n[0],true);setTimeout((function(){run(t,e,n,o,(function(){s.processing(n[0],false)}))}),o.async)}else run(t,e,n,o,(function(){}))};var h=t.tag||d.tag;var b=t.clickBlurs===void 0||t.clickBlurs;p=n("<"+h+"/>").addClass(d.className).attr("tabindex",this.s.dt.settings()[0].iTabIndex).attr("aria-controls",this.s.dt.table().node().id).on("click.dtb",(function(e){e.preventDefault();!p.hasClass(d.disabled)&&t.action&&action(e,c,p,t);b&&p.trigger("blur")})).on("keypress.dtb",(function(e){if(e.keyCode===13){e.preventDefault();!p.hasClass(d.disabled)&&t.action&&action(e,c,p,t)}}));h.toLowerCase()==="a"&&p.attr("href","#");h.toLowerCase()==="button"&&p.attr("type","button");if(d.liner.tag){var v=n("<"+d.liner.tag+"/>").html(text(t.text)).addClass(d.liner.className);d.liner.tag.toLowerCase()==="a"&&v.attr("href","#");p.append(v);u=v}else{p.html(text(t.text));u=p}t.enabled===false&&p.addClass(d.disabled);t.className&&p.addClass(t.className);t.titleAttr&&p.attr("title",text(t.titleAttr));t.attr&&p.attr(t.attr);t.namespace||(t.namespace=".dt-button-"+i++);t.config!==void 0&&t.config.split&&(t.split=t.config.split)}var g=this.c.dom.buttonContainer;var m;m=g&&g.tag?n("<"+g.tag+"/>").addClass(g.className).append(p):p;this._addKey(t);this.c.buttonCreated&&(m=this.c.buttonCreated(t,m));var y;if(o){var x=e?n.extend(true,this.c.dom.split,this.c.dom.collection.split):this.c.dom.split;var C=x.wrapper;y=n("<"+C.tag+"/>").addClass(C.className).append(p);var _=n.extend(t,{autoClose:true,align:x.dropdown.align,attr:{"aria-haspopup":"dialog","aria-expanded":false},className:x.dropdown.className,closeButton:false,splitAlignClass:x.dropdown.splitAlignClass,text:x.dropdown.text});this._addKey(_);var splitAction=function(t,e,o,i){r.split.action.call(e.button(y),t,e,o,i);n(e.table().node()).triggerHandler("buttons-action.dt",[e.button(o),e,o,i]);o.attr("aria-expanded",true)};var w=n('<button class="'+x.dropdown.className+' dt-button"></button>').html(this.c.dom.button.dropHtml).addClass(this.c.dom.button.dropClass).on("click.dtb",(function(t){t.preventDefault();t.stopPropagation();w.hasClass(d.disabled)||splitAction(t,c,w,_);b&&w.trigger("blur")})).on("keypress.dtb",(function(t){if(t.keyCode===13){t.preventDefault();w.hasClass(d.disabled)||splitAction(t,c,w,_)}}));t.split.length===0&&w.addClass("dtb-hide-drop");y.append(w).attr(_.attr)}var A=o?y.get(0):p.get(0);return{conf:t,node:A,nodeChild:A&&A.children&&A.children.length?A.children[0]:null,inserter:o?y:m,buttons:[],inCollection:e,isSplit:o,inSplit:a,collection:null,textNode:u}},
/**
	 * Spin over buttons checking if splits should be enabled or not.
	 * @param {*} buttons Array of buttons to check
	 */
_checkSplitEnable:function(t){t||(t=this.s.buttons);for(var e=0;e<t.length;e++){var o=t[e];if(o.isSplit){var i=o.node.childNodes[1];this._checkAnyEnabled(o.buttons)?n(i).removeClass(this.c.dom.button.disabled).prop("disabled",false):n(i).addClass(this.c.dom.button.disabled).prop("disabled",false)}else o.isCollection&&this._checkSplitEnable(o.buttons)}},
/**
	 * Check an array of buttons and see if any are enabled in it
	 * @param {*} buttons Button array
	 * @returns true if a button is enabled, false otherwise
	 */
_checkAnyEnabled:function(t){for(var e=0;e<t.length;e++)if(!t[e].disabled)return true;return false},
/**
	 * Get the button object from a node (recursive)
	 * @param  {node} node Button node
	 * @param  {array} [buttons] Button array, uses base if not defined
	 * @return {object} Button object
	 * @private
	 */
_nodeToButton:function(t,e){e||(e=this.s.buttons);for(var n=0,o=e.length;n<o;n++){if(e[n].node===t||e[n].nodeChild===t)return e[n];if(e[n].buttons.length){var i=this._nodeToButton(t,e[n].buttons);if(i)return i}}},
/**
	 * Get container array for a button from a button node (recursive)
	 * @param  {node} node Button node
	 * @param  {array} [buttons] Button array, uses base if not defined
	 * @return {array} Button's host array
	 * @private
	 */
_nodeToHost:function(t,e){e||(e=this.s.buttons);for(var n=0,o=e.length;n<o;n++){if(e[n].node===t)return e;if(e[n].buttons.length){var i=this._nodeToHost(t,e[n].buttons);if(i)return i}}},
/**
	 * Handle a key press - determine if any button's key configured matches
	 * what was typed and trigger the action if so.
	 * @param  {string} character The character pressed
	 * @param  {object} e Key event that triggered this call
	 * @private
	 */
_keypress:function(t,e){if(!e._buttonsHandled){var run=function(o,i){if(o.key)if(o.key===t){e._buttonsHandled=true;n(i).click()}else if(n.isPlainObject(o.key)){if(o.key.key!==t)return;if(o.key.shiftKey&&!e.shiftKey)return;if(o.key.altKey&&!e.altKey)return;if(o.key.ctrlKey&&!e.ctrlKey)return;if(o.key.metaKey&&!e.metaKey)return;e._buttonsHandled=true;n(i).click()}};var recurse=function(t){for(var e=0,n=t.length;e<n;e++){run(t[e].conf,t[e].node);t[e].buttons.length&&recurse(t[e].buttons)}};recurse(this.s.buttons)}},
/**
	 * Remove a key from the key listener for this instance (to be used when a
	 * button is removed)
	 * @param  {object} conf Button configuration
	 * @private
	 */
_removeKey:function(t){if(t.key){var e=n.isPlainObject(t.key)?t.key.key:t.key;var o=this.s.listenKeys.split("");var i=n.inArray(e,o);o.splice(i,1);this.s.listenKeys=o.join("")}},
/**
	 * Resolve a button configuration
	 * @param  {string|function|object} conf Button config to resolve
	 * @return {object} Button configuration
	 * @private
	 */
_resolveExtends:function(t){var e=this;var o=this.s.dt;var i,a;var toConfObject=function(i){var a=0;while(!n.isPlainObject(i)&&!Array.isArray(i)){if(i===void 0)return;if(typeof i==="function"){i=i.call(e,o,t);if(!i)return false}else if(typeof i==="string"){if(!r[i])return{html:i};i=r[i]}a++;if(a>30)throw"Buttons: Too many iterations"}return Array.isArray(i)?i:n.extend({},i)};t=toConfObject(t);while(t&&t.extend){if(!r[t.extend])throw"Cannot extend unknown button type: "+t.extend;var s=toConfObject(r[t.extend]);if(Array.isArray(s))return s;if(!s)return false;var l=s.className;t.config!==void 0&&s.config!==void 0&&(t.config=n.extend({},s.config,t.config));t=n.extend({},s,t);l&&t.className!==l&&(t.className=l+" "+t.className);t.extend=s.extend}var u=t.postfixButtons;if(u){t.buttons||(t.buttons=[]);for(i=0,a=u.length;i<a;i++)t.buttons.push(u[i])}var c=t.prefixButtons;if(c){t.buttons||(t.buttons=[]);for(i=0,a=c.length;i<a;i++)t.buttons.splice(i,0,c[i])}return t},
/**
	 * Display (and replace if there is an existing one) a popover attached to a button
	 * @param {string|node} content Content to show
	 * @param {DataTable.Api} hostButton DT API instance of the button
	 * @param {object} inOpts Options (see object below for all options)
	 */
_popover:function(t,e,o){var i=e;var r=this.c;var a=false;var s=n.extend({align:"button-left",autoClose:false,background:true,backgroundClassName:"dt-button-background",closeButton:true,containerClassName:r.dom.collection.container.className,contentClassName:r.dom.collection.container.content.className,collectionLayout:"",collectionTitle:"",dropup:false,fade:400,popoverTitle:"",rightAlignClassName:"dt-button-right",tag:r.dom.collection.container.tag},o);var l=s.tag+"."+s.containerClassName.replace(/ /g,".");var u=e.node();var c=s.collectionLayout.includes("fixed")?n("body"):e.node();var close=function(){a=true;_fadeOut(n(l),s.fade,(function(){n(this).detach()}));n(i.buttons('[aria-haspopup="dialog"][aria-expanded="true"]').nodes()).attr("aria-expanded","false");n("div.dt-button-background").off("click.dtb-collection");Buttons.background(false,s.backgroundClassName,s.fade,c);n(window).off("resize.resize.dtb-collection");n("body").off(".dtb-collection");i.off("buttons-action.b-internal");i.off("destroy");n("body").trigger("buttons-popover-hide.dt")};if(t!==false){var d=n(i.buttons('[aria-haspopup="dialog"][aria-expanded="true"]').nodes());if(d.length){c.closest(l).length&&(c=d.eq(0));close()}if(s.sort){var f=n("button",t).map((function(t,e){return{text:n(e).text(),el:e}})).toArray();f.sort((function(t,e){return t.text.localeCompare(e.text)}));n(t).append(f.map((function(t){return t.el})))}var p=n(".dt-button",t).length;var h="";p===3?h="dtb-b3":p===2?h="dtb-b2":p===1&&(h="dtb-b1");var b=n("<"+s.tag+"/>").addClass(s.containerClassName).addClass(s.collectionLayout).addClass(s.splitAlignClass).addClass(h).css("display","none").attr({"aria-modal":true,role:"dialog"});t=n(t).addClass(s.contentClassName).attr("role","menu").appendTo(b);u.attr("aria-expanded","true");c.parents("body")[0]!==document.body&&(c=n(document.body).children("div, section, p").last());s.popoverTitle?b.prepend('<div class="dt-button-collection-title">'+s.popoverTitle+"</div>"):s.collectionTitle&&b.prepend('<div class="dt-button-collection-title">'+s.collectionTitle+"</div>");s.closeButton&&b.prepend('<div class="dtb-popover-close">&times;</div>').addClass("dtb-collection-closeable");_fadeIn(b.insertAfter(c),s.fade);var v=n(e.table().container());var g=b.css("position");if(s.span==="container"||s.align==="dt-container"){c=c.parent();b.css("width",v.width())}if(g==="absolute"){var m=n(c[0].offsetParent);var y=c.position();var x=c.offset();var C=m.offset();var _=m.position();var w=window.getComputedStyle(m[0]);C.height=m.outerHeight();C.width=m.width()+parseFloat(w.paddingLeft);C.right=C.left+C.width;C.bottom=C.top+C.height;var A=y.top+c.outerHeight();var k=y.left;b.css({top:A,left:k});w=window.getComputedStyle(b[0]);var N=b.offset();N.height=b.outerHeight();N.width=b.outerWidth();N.right=N.left+N.width;N.bottom=N.top+N.height;N.marginTop=parseFloat(w.marginTop);N.marginBottom=parseFloat(w.marginBottom);s.dropup&&(A=y.top-N.height-N.marginTop-N.marginBottom);(s.align==="button-right"||b.hasClass(s.rightAlignClassName))&&(k=y.left-N.width+c.outerWidth());s.align!=="dt-container"&&s.align!=="container"||k<y.left&&(k=-y.left);_.left+k+N.width>n(window).width()&&(k=n(window).width()-N.width-_.left);x.left+k<0&&(k=-x.left);_.top+A+N.height>n(window).height()+n(window).scrollTop()&&(A=y.top-N.height-N.marginTop-N.marginBottom);m.offset().top+A<n(window).scrollTop()&&(A=y.top+c.outerHeight());b.css({top:A,left:k})}else{var place=function(){var t=n(window).height()/2;var e=b.height()/2;e>t&&(e=t);b.css("marginTop",e*-1)};place();n(window).on("resize.dtb-collection",(function(){place()}))}s.background&&Buttons.background(true,s.backgroundClassName,s.fade,s.backgroundHost||c);n("div.dt-button-background").on("click.dtb-collection",(function(){}));s.autoClose&&setTimeout((function(){i.on("buttons-action.b-internal",(function(t,e,n,o){o[0]!==c[0]&&close()}))}),0);n(b).trigger("buttons-popover.dt");i.on("destroy",close);setTimeout((function(){a=false;n("body").on("click.dtb-collection",(function(e){if(!a){var o=n.fn.addBack?"addBack":"andSelf";var i=n(e.target).parent()[0];(!n(e.target).parents()[o]().filter(t).length&&!n(i).hasClass("dt-buttons")||n(e.target).hasClass("dt-button-background"))&&close()}})).on("keyup.dtb-collection",(function(t){t.keyCode===27&&close()})).on("keydown.dtb-collection",(function(e){var o=n("a, button",t);var i=document.activeElement;if(e.keyCode===9)if(o.index(i)===-1){o.first().focus();e.preventDefault()}else if(e.shiftKey){if(i===o[0]){o.last().focus();e.preventDefault()}}else if(i===o.last()[0]){o.first().focus();e.preventDefault()}}))}),0)}else close()}});
/**
 * Show / hide a background layer behind a collection
 * @param  {boolean} Flag to indicate if the background should be shown or
 *   hidden
 * @param  {string} Class to assign to the background
 * @static
 */Buttons.background=function(t,e,o,i){o===void 0&&(o=400);i||(i=document.body);t?_fadeIn(n("<div/>").addClass(e).css("display","none").insertAfter(i),o):_fadeOut(n("div."+e),o,(function(){n(this).removeClass(e).remove()}))};
/**
 * Instance selector - select Buttons instances based on an instance selector
 * value from the buttons assigned to a DataTable. This is only useful if
 * multiple instances are attached to a DataTable.
 * @param  {string|int|array} Instance selector - see `instance-selector`
 *   documentation on the DataTables site
 * @param  {array} Button instance array that was attached to the DataTables
 *   settings object
 * @return {array} Buttons instances
 * @static
 */Buttons.instanceSelector=function(t,e){if(t===void 0||t===null)return n.map(e,(function(t){return t.inst}));var o=[];var i=n.map(e,(function(t){return t.name}));var process=function(t){if(Array.isArray(t))for(var r=0,a=t.length;r<a;r++)process(t[r]);else if(typeof t==="string")if(t.indexOf(",")!==-1)process(t.split(","));else{var s=n.inArray(t.trim(),i);s!==-1&&o.push(e[s].inst)}else if(typeof t==="number")o.push(e[t].inst);else if(typeof t==="object"&&t.nodeName)for(var l=0;l<e.length;l++)e[l].inst.dom.container[0]===t&&o.push(e[l].inst);else typeof t==="object"&&o.push(t)};process(t);return o};
/**
 * Button selector - select one or more buttons from a selector input so some
 * operation can be performed on them.
 * @param  {array} Button instances array that the selector should operate on
 * @param  {string|int|node|jQuery|array} Button selector - see
 *   `button-selector` documentation on the DataTables site
 * @return {array} Array of objects containing `inst` and `idx` properties of
 *   the selected buttons so you know which instance each button belongs to.
 * @static
 */Buttons.buttonSelector=function(t,e){var o=[];var nodeBuilder=function(t,e,n){var o;var i;for(var r=0,a=e.length;r<a;r++){o=e[r];if(o){i=n!==void 0?n+r:r+"";t.push({node:o.node,name:o.conf.name,idx:i});o.buttons&&nodeBuilder(t,o.buttons,i+"-")}}};var run=function(t,e){var i,r;var a=[];nodeBuilder(a,e.s.buttons);var s=n.map(a,(function(t){return t.node}));if(Array.isArray(t)||t instanceof n)for(i=0,r=t.length;i<r;i++)run(t[i],e);else if(t===null||t===void 0||t==="*")for(i=0,r=a.length;i<r;i++)o.push({inst:e,node:a[i].node});else if(typeof t==="number")e.s.buttons[t]&&o.push({inst:e,node:e.s.buttons[t].node});else if(typeof t==="string")if(t.indexOf(",")!==-1){var l=t.split(",");for(i=0,r=l.length;i<r;i++)run(l[i].trim(),e)}else if(t.match(/^\d+(\-\d+)*$/)){var u=n.map(a,(function(t){return t.idx}));o.push({inst:e,node:a[n.inArray(t,u)].node})}else if(t.indexOf(":name")!==-1){var c=t.replace(":name","");for(i=0,r=a.length;i<r;i++)a[i].name===c&&o.push({inst:e,node:a[i].node})}else n(s).filter(t).each((function(){o.push({inst:e,node:this})}));else if(typeof t==="object"&&t.nodeName){var d=n.inArray(t,s);d!==-1&&o.push({inst:e,node:s[d]})}};for(var i=0,r=t.length;i<r;i++){var a=t[i];run(e,a)}return o};
/**
 * Default function used for formatting output data.
 * @param {*} str Data to strip
 */Buttons.stripData=function(t,n){t!==null&&typeof t==="object"&&t.nodeName&&t.nodeType&&(t=t.innerHTML);if(typeof t!=="string")return t;t=Buttons.stripHtmlScript(t);t=Buttons.stripHtmlComments(t);n&&!n.stripHtml||(t=e.util.stripHtml(t));n&&!n.trim||(t=t.trim());n&&!n.stripNewlines||(t=t.replace(/\n/g," "));if(!n||n.decodeEntities)if(a)t=a(t);else{l.innerHTML=t;t=l.value}if((!n||n.escapeExcelFormula)&&t.match(/^[=+\-@\t\r]/)){console.log("matching and updateing");t="'"+t}return t};
/**
 * Provide a custom entity decoding function - e.g. a regex one, which can be
 * much faster than the built in DOM option, but also larger code size.
 * @param {function} fn
 */Buttons.entityDecoder=function(t){a=t};
/**
 * Common function for stripping HTML comments
 *
 * @param {*} input 
 * @returns 
 */Buttons.stripHtmlComments=function(t){var e;do{e=t;t=t.replace(/(<!--.*?--!?>)|(<!--[\S\s]+?--!?>)|(<!--[\S\s]*?$)/g,"")}while(t!==e);return t};
/**
 * Common function for stripping HTML script tags
 *
 * @param {*} input 
 * @returns 
 */Buttons.stripHtmlScript=function(t){var e;do{e=t;t=t.replace(/<script\b[^<]*(?:(?!<\/script[^>]*>)<[^<]*)*<\/script[^>]*>/gi,"")}while(t!==e);return t};
/**
 * Buttons defaults. For full documentation, please refer to the docs/option
 * directory or the DataTables site.
 * @type {Object}
 * @static
 */Buttons.defaults={buttons:["copy","excel","csv","pdf","print"],name:"main",tabIndex:0,dom:{container:{tag:"div",className:"dt-buttons"},collection:{container:{className:"dt-button-collection",content:{className:"",tag:"div"},tag:"div"}},button:{tag:"button",className:"dt-button",active:"dt-button-active",disabled:"disabled",spacer:{className:"dt-button-spacer",tag:"span"},liner:{tag:"span",className:""},dropClass:"",dropHtml:'<span class="dt-button-down-arrow">&#x25BC;</span>'},split:{action:{className:"dt-button-split-drop-button dt-button",tag:"button"},dropdown:{align:"split-right",className:"dt-button-split-drop",splitAlignClass:"dt-button-split-left",tag:"button"},wrapper:{className:"dt-button-split",tag:"div"}}}};
/**
 * Version information
 * @type {string}
 * @static
 */Buttons.version="3.2.3";n.extend(r,{collection:{text:function(t){return t.i18n("buttons.collection","Collection")},className:"buttons-collection",closeButton:false,dropIcon:true,init:function(t,e){e.attr("aria-expanded",false)},action:function(t,e,o,i){i._collection.parents("body").length?this.popover(false,i):this.popover(i._collection,i);t.type==="keypress"&&n("a, button",i._collection).eq(0).focus()},attr:{"aria-haspopup":"dialog"}},split:{text:function(t){return t.i18n("buttons.split","Split")},className:"buttons-split",closeButton:false,init:function(t,e){return e.attr("aria-expanded",false)},action:function(t,e,n,o){this.popover(o._collection,o)},attr:{"aria-haspopup":"dialog"}},copy:function(){if(r.copyHtml5)return"copyHtml5"},csv:function(t,e){if(r.csvHtml5&&r.csvHtml5.available(t,e))return"csvHtml5"},excel:function(t,e){if(r.excelHtml5&&r.excelHtml5.available(t,e))return"excelHtml5"},pdf:function(t,e){if(r.pdfHtml5&&r.pdfHtml5.available(t,e))return"pdfHtml5"},pageLength:function(t){var e=t.settings()[0].aLengthMenu;var o=[];var i=[];var text=function(t){return t.i18n("buttons.pageLength",{"-1":"Show all rows",_:"Show %d rows"},t.page.len())};if(Array.isArray(e[0])){o=e[0];i=e[1]}else for(var r=0;r<e.length;r++){var a=e[r];if(n.isPlainObject(a)){o.push(a.value);i.push(a.label)}else{o.push(a);i.push(a)}}return{extend:"collection",text:text,className:"buttons-page-length",autoClose:true,buttons:n.map(o,(function(t,e){return{text:i[e],className:"button-page-length",action:function(e,n){n.page.len(t).draw()},init:function(e,n,o){var i=this;var fn=function(){i.active(e.page.len()===t)};e.on("length.dt"+o.namespace,fn);fn()},destroy:function(t,e,n){t.off("length.dt"+n.namespace)}}})),init:function(t,e,n){var o=this;t.on("length.dt"+n.namespace,(function(){o.text(n.text)}))},destroy:function(t,e,n){t.off("length.dt"+n.namespace)}}},spacer:{style:"empty",spacer:true,text:function(t){return t.i18n("buttons.spacer","")}}});e.Api.register("buttons()",(function(t,e){if(e===void 0){e=t;t=void 0}this.selector.buttonGroup=t;var n=this.iterator(true,"table",(function(n){if(n._buttons)return Buttons.buttonSelector(Buttons.instanceSelector(t,n._buttons),e)}),true);n._groupSelector=t;return n}));e.Api.register("button()",(function(t,e){var n=this.buttons(t,e);n.length>1&&n.splice(1,n.length);return n}));e.Api.registerPlural("buttons().active()","button().active()",(function(t){return t===void 0?this.map((function(t){return t.inst.active(t.node)})):this.each((function(e){e.inst.active(e.node,t)}))}));e.Api.registerPlural("buttons().action()","button().action()",(function(t){return t===void 0?this.map((function(t){return t.inst.action(t.node)})):this.each((function(e){e.inst.action(e.node,t)}))}));e.Api.registerPlural("buttons().collectionRebuild()","button().collectionRebuild()",(function(t){return this.each((function(e){for(var n=0;n<t.length;n++)typeof t[n]==="object"&&(t[n].parentConf=e);e.inst.collectionRebuild(e.node,t)}))}));e.Api.register(["buttons().enable()","button().enable()"],(function(t){return this.each((function(e){e.inst.enable(e.node,t)}))}));e.Api.register(["buttons().disable()","button().disable()"],(function(){return this.each((function(t){t.inst.disable(t.node)}))}));e.Api.register("button().index()",(function(){var t=null;this.each((function(e){var n=e.inst.index(e.node);n!==null&&(t=n)}));return t}));e.Api.registerPlural("buttons().nodes()","button().node()",(function(){var t=n();n(this.each((function(e){t=t.add(e.inst.node(e.node))})));return t}));e.Api.registerPlural("buttons().processing()","button().processing()",(function(t){return t===void 0?this.map((function(t){return t.inst.processing(t.node)})):this.each((function(e){e.inst.processing(e.node,t)}))}));e.Api.registerPlural("buttons().text()","button().text()",(function(t){return t===void 0?this.map((function(t){return t.inst.text(t.node)})):this.each((function(e){e.inst.text(e.node,t)}))}));e.Api.registerPlural("buttons().trigger()","button().trigger()",(function(){return this.each((function(t){t.inst.node(t.node).trigger("click")}))}));e.Api.register("button().popover()",(function(t,e){return this.map((function(n){return n.inst._popover(t,this.button(this[0].node),e)}))}));e.Api.register("buttons().containers()",(function(){var t=n();var e=this._groupSelector;this.iterator(true,"table",(function(n){if(n._buttons){var o=Buttons.instanceSelector(e,n._buttons);for(var i=0,r=o.length;i<r;i++)t=t.add(o[i].container())}}));return t}));e.Api.register("buttons().container()",(function(){return this.containers().eq(0)}));e.Api.register("button().add()",(function(t,e,n){var o=this.context;if(o.length){var i=Buttons.instanceSelector(this._groupSelector,o[0]._buttons);i.length&&i[0].add(e,t,n)}return this.button(this._groupSelector,t)}));e.Api.register("buttons().destroy()",(function(){this.pluck("inst").unique().each((function(t){t.destroy()}));return this}));e.Api.registerPlural("buttons().remove()","buttons().remove()",(function(){this.each((function(t){t.inst.remove(t.node)}));return this}));var s;e.Api.register("buttons.info()",(function(t,e,o){var i=this;if(t===false){this.off("destroy.btn-info");_fadeOut(n("#datatables_buttons_info"),400,(function(){n(this).remove()}));clearTimeout(s);s=null;return this}s&&clearTimeout(s);n("#datatables_buttons_info").length&&n("#datatables_buttons_info").remove();t=t?"<h2>"+t+"</h2>":"";_fadeIn(n('<div id="datatables_buttons_info" class="dt-button-info"/>').html(t).append(n("<div/>")[typeof e==="string"?"html":"append"](e)).css("display","none").appendTo("body"));o!==void 0&&o!==0&&(s=setTimeout((function(){i.buttons.info(false)}),o));this.on("destroy.btn-info",(function(){i.buttons.info(false)}));return this}));e.Api.register("buttons.exportData()",(function(t){if(this.context.length)return _exportData(new e.Api(this.context[0]),t)}));e.Api.register("buttons.exportInfo()",(function(t){t||(t={});return{filename:_filename(t,this),title:_title(t,this),messageTop:_message(this,t,t.message||t.messageTop,"top"),messageBottom:_message(this,t,t.messageBottom,"bottom")}}));
/**
 * Get the file name for an exported file.
 *
 * @param {object} config Button configuration
 * @param {object} dt DataTable instance
 */var _filename=function(t,e){var o=t.filename==="*"&&t.title!=="*"&&t.title!==void 0&&t.title!==null&&t.title!==""?t.title:t.filename;typeof o==="function"&&(o=o(t,e));if(o===void 0||o===null)return null;o.indexOf("*")!==-1&&(o=o.replace(/\*/g,n("head > title").text()).trim());o=o.replace(/[^a-zA-Z0-9_\u00A1-\uFFFF\.,\-_ !\(\)]/g,"");var i=_stringOrFunction(t.extension,t,e);i||(i="");return o+i};
/**
 * Simply utility method to allow parameters to be given as a function
 *
 * @param {undefined|string|function} option Option
 * @return {null|string} Resolved value
 */var _stringOrFunction=function(t,e,n){return t===null||t===void 0?null:typeof t==="function"?t(e,n):t};
/**
 * Get the title for an exported file.
 *
 * @param {object} config	Button configuration
 */var _title=function(t,e){var o=_stringOrFunction(t.title,t,e);return o===null?null:o.indexOf("*")!==-1?o.replace(/\*/g,n("head > title").text()||"Exported data"):o};var _message=function(t,e,o,i){var r=_stringOrFunction(o,e,t);if(r===null)return null;var a=n("caption",t.table().container()).eq(0);if(r==="*"){var s=a.css("caption-side");return s!==i?null:a.length?a.text():""}return r};var l=n("<textarea/>")[0];var _exportData=function(t,e){var o=n.extend(true,{},{rows:null,columns:"",modifier:{search:"applied",order:"applied"},orthogonal:"display",stripHtml:true,stripNewlines:true,decodeEntities:true,escapeExcelFormula:false,trim:true,format:{header:function(t){return Buttons.stripData(t,o)},footer:function(t){return Buttons.stripData(t,o)},body:function(t){return Buttons.stripData(t,o)}},customizeData:null,customizeZip:null},e);var i=t.columns(o.columns).indexes().map((function(e){var n=t.column(e);return o.format.header(n.title(),e,n.header())})).toArray();var r=t.table().footer()?t.columns(o.columns).indexes().map((function(e){var i=t.column(e).footer();var r="";if(i){var a=n(".dt-column-title",i);r=a.length?a.html():n(i).html()}return o.format.footer(r,e,i)})).toArray():null;var a=n.extend({},o.modifier);t.select&&typeof t.select.info==="function"&&a.selected===void 0&&t.rows(o.rows,n.extend({selected:true},a)).any()&&n.extend(a,{selected:true});var s=t.rows(o.rows,a).indexes().toArray();var l=t.cells(s,o.columns,{order:a.order});var u=l.render(o.orthogonal).toArray();var c=l.nodes().toArray();var d=l.indexes().toArray();var f=t.columns(o.columns).count();var p=f>0?u.length/f:0;var h=[];var b=0;for(var v=0,g=p;v<g;v++){var m=[f];for(var y=0;y<f;y++){m[y]=o.format.body(u[b],d[b].row,d[b].column,c[b]);b++}h[v]=m}var x={header:i,headerStructure:_headerFormatter(o.format.header,t.table().header.structure(o.columns)),footer:r,footerStructure:_headerFormatter(o.format.footer,t.table().footer.structure(o.columns)),body:h};o.customizeData&&o.customizeData(x);return x};function _headerFormatter(t,e){for(var n=0;n<e.length;n++)for(var o=0;o<e[n].length;o++){var i=e[n][o];i&&(i.title=t(i.title,o,i.cell))}return e}n.fn.dataTable.Buttons=Buttons;n.fn.DataTable.Buttons=Buttons;n(document).on("init.dt plugin-init.dt",(function(t,n){if(t.namespace==="dt"){var o=n.oInit.buttons||e.defaults.buttons;o&&!n._buttons&&new Buttons(n,o).container()}}));function _init(t,n){var o=new e.Api(t);var i=n||(o.init().buttons||e.defaults.buttons);return new Buttons(o,i).container()}e.ext.feature.push({fnInit:_init,cFeature:"B"});e.feature&&e.feature.register("buttons",_init);

