// datatables.net@2.2.2 downloaded from https://ga.jspm.io/npm:datatables.net@2.2.2/js/dataTables.mjs

import e from"jquery";var t=e;var DataTable=function(e,r){if(DataTable.factory(e,r))return DataTable;if(this instanceof DataTable)return t(e).DataTable(r);r=e;var i=this;var o=r===void 0;var l=this.length;o&&(r={});this.api=function(){return new n(this)};this.each((function(){var e={};var s=l>1?_fnExtend(e,r,true):r;var u,f=0;var c=this.getAttribute("id");var d=DataTable.defaults;var p=t(this);if(this.nodeName.toLowerCase()=="table"){t(this).trigger("options.dt",s);_fnCompatOpts(d);_fnCompatCols(d.column);_fnCamelToHungarian(d,d,true);_fnCamelToHungarian(d.column,d.column,true);_fnCamelToHungarian(d,t.extend(s,p.data()),true);var v=DataTable.settings;for(f=0,u=v.length;f<u;f++){var h=v[f];if(h.nTable==this||h.nTHead&&h.nTHead.parentNode==this||h.nTFoot&&h.nTFoot.parentNode==this){var m=s.bRetrieve!==void 0?s.bRetrieve:d.bRetrieve;var _=s.bDestroy!==void 0?s.bDestroy:d.bDestroy;if(o||m)return h.oInstance;if(_){new DataTable.Api(h).destroy();break}_fnLog(h,0,"Cannot reinitialise DataTable",3);return}if(h.sTableId==this.id){v.splice(f,1);break}}if(c===null||c===""){c="DataTables_Table_"+DataTable.ext._unique++;this.id=c}var b=t.extend(true,{},DataTable.models.oSettings,{sDestroyWidth:p[0].style.width,sInstance:c,sTableId:c,colgroup:t("<colgroup>").prependTo(this),fastData:function(e,t,r){return _fnGetCellData(b,e,t,r)}});b.nTable=this;b.oInit=s;v.push(b);b.api=new n(b);b.oInstance=i.length===1?i:p.dataTable();_fnCompatOpts(s);s.aLengthMenu&&!s.iDisplayLength&&(s.iDisplayLength=Array.isArray(s.aLengthMenu[0])?s.aLengthMenu[0][0]:t.isPlainObject(s.aLengthMenu[0])?s.aLengthMenu[0].value:s.aLengthMenu[0]);s=_fnExtend(t.extend(true,{},d),s);_fnMap(b.oFeatures,s,["bPaginate","bLengthChange","bFilter","bSort","bSortMulti","bInfo","bProcessing","bAutoWidth","bSortClasses","bServerSide","bDeferRender"]);_fnMap(b,s,["ajax","fnFormatNumber","sServerMethod","aaSorting","aaSortingFixed","aLengthMenu","sPaginationType","iStateDuration","bSortCellsTop","iTabIndex","sDom","fnStateLoadCallback","fnStateSaveCallback","renderer","searchDelay","rowId","caption","layout","orderDescReverse","typeDetect",["iCookieDuration","iStateDuration"],["oSearch","oPreviousSearch"],["aoSearchCols","aoPreSearchCols"],["iDisplayLength","_iDisplayLength"]]);_fnMap(b.oScroll,s,[["sScrollX","sX"],["sScrollXInner","sXInner"],["sScrollY","sY"],["bScrollCollapse","bCollapse"]]);_fnMap(b.oLanguage,s,"fnInfoCallback");_fnCallbackReg(b,"aoDrawCallback",s.fnDrawCallback);_fnCallbackReg(b,"aoStateSaveParams",s.fnStateSaveParams);_fnCallbackReg(b,"aoStateLoadParams",s.fnStateLoadParams);_fnCallbackReg(b,"aoStateLoaded",s.fnStateLoaded);_fnCallbackReg(b,"aoRowCallback",s.fnRowCallback);_fnCallbackReg(b,"aoRowCreatedCallback",s.fnCreatedRow);_fnCallbackReg(b,"aoHeaderCallback",s.fnHeaderCallback);_fnCallbackReg(b,"aoFooterCallback",s.fnFooterCallback);_fnCallbackReg(b,"aoInitComplete",s.fnInitComplete);_fnCallbackReg(b,"aoPreDrawCallback",s.fnPreDrawCallback);b.rowIdFn=g(s.rowId);_fnBrowserDetect(b);var y=b.oClasses;t.extend(y,DataTable.ext.classes,s.oClasses);p.addClass(y.table);b.oFeatures.bPaginate||(s.iDisplayStart=0);if(b.iInitDisplayStart===void 0){b.iInitDisplayStart=s.iDisplayStart;b._iDisplayStart=s.iDisplayStart}var D=s.iDeferLoading;if(D!==null){b.deferLoading=true;var C=Array.isArray(D);b._iRecordsDisplay=C?D[0]:D;b._iRecordsTotal=C?D[1]:D}var S=[];var w=this.getElementsByTagName("thead");var x=_fnDetectHeader(b,w[0]);if(s.aoColumns)S=s.aoColumns;else if(x.length)for(f=0,u=x[0].length;f<u;f++)S.push(null);for(f=0,u=S.length;f<u;f++)_fnAddColumn(b);_fnApplyColumnDefs(b,s.aoColumnDefs,S,x,(function(e,t){_fnColumnOptions(b,e,t)}));var T=p.children("tbody").find("tr").eq(0);if(T.length){var a=function(e,t){return e.getAttribute("data-"+t)!==null?t:null};t(T[0]).children("th, td").each((function(e,t){var r=b.aoColumns[e];r||_fnLog(b,0,"Incorrect column count",18);if(r.mData===e){var n=a(t,"sort")||a(t,"order");var i=a(t,"filter")||a(t,"search");if(n!==null||i!==null){r.mData={_:e+".display",sort:n!==null?e+".@data-"+n:void 0,type:n!==null?e+".@data-"+n:void 0,filter:i!==null?e+".@data-"+i:void 0};r._isArrayHost=true;_fnColumnOptions(b,e)}}}))}_fnCallbackReg(b,"aoDrawCallback",_fnSaveState);var A=b.oFeatures;s.bStateSave&&(A.bStateSave=true);if(s.aaSorting===void 0){var F=b.aaSorting;for(f=0,u=F.length;f<u;f++)F[f][1]=b.aoColumns[f].asSorting[0]}_fnSortingClasses(b);_fnCallbackReg(b,"aoDrawCallback",(function(){(b.bSorted||_fnDataSource(b)==="ssp"||A.bDeferRender)&&_fnSortingClasses(b)}));var I=p.children("caption");if(b.caption){I.length===0&&(I=t("<caption/>").appendTo(p));I.html(b.caption)}if(I.length){I[0]._captionSide=I.css("caption-side");b.captionNode=I[0]}w.length===0&&(w=t("<thead/>").appendTo(p));b.nTHead=w[0];var L=p.children("tbody");L.length===0&&(L=t("<tbody/>").insertAfter(w));b.nTBody=L[0];var R=p.children("tfoot");R.length===0&&(R=t("<tfoot/>").appendTo(p));b.nTFoot=R[0];b.aiDisplay=b.aiDisplayMaster.slice();b.bInitialised=true;var N=b.oLanguage;t.extend(true,N,s.oLanguage);if(N.sUrl)t.ajax({dataType:"json",url:N.sUrl,success:function(e){_fnCamelToHungarian(d.oLanguage,e);t.extend(true,N,e,b.oInit.oLanguage);_fnCallbackFire(b,null,"i18n",[b],true);_fnInitialise(b)},error:function(){_fnLog(b,0,"i18n file loading error",21);_fnInitialise(b)}});else{_fnCallbackFire(b,null,"i18n",[b],true);_fnInitialise(b)}}else _fnLog(null,0,"Non-table node initialisation ("+this.nodeName+")",2)}));i=null;return this};DataTable.ext=r={
/**
	 * Buttons. For use with the Buttons extension for DataTables. This is
	 * defined here so other extensions can define buttons regardless of load
	 * order. It is _not_ used by DataTables core.
	 *
	 *  @type object
	 *  @default {}
	 */
buttons:{},
/**
	 * Element class names
	 *
	 *  @type object
	 *  @default {}
	 */
classes:{},
/**
	 * DataTables build type (expanded by the download builder)
	 *
	 *  @type string
	 */
builder:"-source-",
/**
	 * Error reporting.
	 * 
	 * How should DataTables report an error. Can take the value 'alert',
	 * 'throw', 'none' or a function.
	 *
	 *  @type string|function
	 *  @default alert
	 */
errMode:"alert",feature:[],features:{},
/**
	 * Row searching.
	 * 
	 * This method of searching is complimentary to the default type based
	 * searching, and a lot more comprehensive as it allows you complete control
	 * over the searching logic. Each element in this array is a function
	 * (parameters described below) that is called for every row in the table,
	 * and your logic decides if it should be included in the searching data set
	 * or not.
	 *
	 * Searching functions have the following input parameters:
	 *
	 * 1. `{object}` DataTables settings object: see
	 *    {@link DataTable.models.oSettings}
	 * 2. `{array|object}` Data for the row to be processed (same as the
	 *    original format that was passed in as the data source, or an array
	 *    from a DOM data source
	 * 3. `{int}` Row index ({@link DataTable.models.oSettings.aoData}), which
	 *    can be useful to retrieve the `TR` element if you need DOM interaction.
	 *
	 * And the following return is expected:
	 *
	 * * {boolean} Include the row in the searched result set (true) or not
	 *   (false)
	 *
	 * Note that as with the main search ability in DataTables, technically this
	 * is "filtering", since it is subtractive. However, for consistency in
	 * naming we call it searching here.
	 *
	 *  @type array
	 *  @default []
	 *
	 *  @example
	 *    // The following example shows custom search being applied to the
	 *    // fourth column (i.e. the data[3] index) based on two input values
	 *    // from the end-user, matching the data in a certain range.
	 *    $.fn.dataTable.ext.search.push(
	 *      function( settings, data, dataIndex ) {
	 *        var min = document.getElementById('min').value * 1;
	 *        var max = document.getElementById('max').value * 1;
	 *        var version = data[3] == "-" ? 0 : data[3]*1;
	 *
	 *        if ( min == "" && max == "" ) {
	 *          return true;
	 *        }
	 *        else if ( min == "" && version < max ) {
	 *          return true;
	 *        }
	 *        else if ( min < version && "" == max ) {
	 *          return true;
	 *        }
	 *        else if ( min < version && version < max ) {
	 *          return true;
	 *        }
	 *        return false;
	 *      }
	 *    );
	 */
search:[],
/**
	 * Selector extensions
	 *
	 * The `selector` option can be used to extend the options available for the
	 * selector modifier options (`selector-modifier` object data type) that
	 * each of the three built in selector types offer (row, column and cell +
	 * their plural counterparts). For example the Select extension uses this
	 * mechanism to provide an option to select only rows, columns and cells
	 * that have been marked as selected by the end user (`{selected: true}`),
	 * which can be used in conjunction with the existing built in selector
	 * options.
	 *
	 * Each property is an array to which functions can be pushed. The functions
	 * take three attributes:
	 *
	 * * Settings object for the host table
	 * * Options object (`selector-modifier` object type)
	 * * Array of selected item indexes
	 *
	 * The return is an array of the resulting item indexes after the custom
	 * selector has been applied.
	 *
	 *  @type object
	 */
selector:{cell:[],column:[],row:[]},
/**
	 * Legacy configuration options. Enable and disable legacy options that
	 * are available in DataTables.
	 *
	 *  @type object
	 */
legacy:{
/**
		 * Enable / disable DataTables 1.9 compatible server-side processing
		 * requests
		 *
		 *  @type boolean
		 *  @default null
		 */
ajax:null},
/**
	 * Pagination plug-in methods.
	 * 
	 * Each entry in this object is a function and defines which buttons should
	 * be shown by the pagination rendering method that is used for the table:
	 * {@link DataTable.ext.renderer.pageButton}. The renderer addresses how the
	 * buttons are displayed in the document, while the functions here tell it
	 * what buttons to display. This is done by returning an array of button
	 * descriptions (what each button will do).
	 *
	 * Pagination types (the four built in options and any additional plug-in
	 * options defined here) can be used through the `paginationType`
	 * initialisation parameter.
	 *
	 * The functions defined take two parameters:
	 *
	 * 1. `{int} page` The current page index
	 * 2. `{int} pages` The number of pages in the table
	 *
	 * Each function is expected to return an array where each element of the
	 * array can be one of:
	 *
	 * * `first` - Jump to first page when activated
	 * * `last` - Jump to last page when activated
	 * * `previous` - Show previous page when activated
	 * * `next` - Show next page when activated
	 * * `{int}` - Show page of the index given
	 * * `{array}` - A nested array containing the above elements to add a
	 *   containing 'DIV' element (might be useful for styling).
	 *
	 * Note that DataTables v1.9- used this object slightly differently whereby
	 * an object with two functions would be defined for each plug-in. That
	 * ability is still supported by DataTables 1.10+ to provide backwards
	 * compatibility, but this option of use is now decremented and no longer
	 * documented in DataTables 1.10+.
	 *
	 *  @type object
	 *  @default {}
	 *
	 *  @example
	 *    // Show previous, next and current page buttons only
	 *    $.fn.dataTableExt.oPagination.current = function ( page, pages ) {
	 *      return [ 'previous', page, 'next' ];
	 *    };
	 */
pager:{},renderer:{pageButton:{},header:{}},
/**
	 * Ordering plug-ins - custom data source
	 * 
	 * The extension options for ordering of data available here is complimentary
	 * to the default type based ordering that DataTables typically uses. It
	 * allows much greater control over the the data that is being used to
	 * order a column, but is necessarily therefore more complex.
	 * 
	 * This type of ordering is useful if you want to do ordering based on data
	 * live from the DOM (for example the contents of an 'input' element) rather
	 * than just the static string that DataTables knows of.
	 * 
	 * The way these plug-ins work is that you create an array of the values you
	 * wish to be ordering for the column in question and then return that
	 * array. The data in the array much be in the index order of the rows in
	 * the table (not the currently ordering order!). Which order data gathering
	 * function is run here depends on the `dt-init columns.orderDataType`
	 * parameter that is used for the column (if any).
	 *
	 * The functions defined take two parameters:
	 *
	 * 1. `{object}` DataTables settings object: see
	 *    {@link DataTable.models.oSettings}
	 * 2. `{int}` Target column index
	 *
	 * Each function is expected to return an array:
	 *
	 * * `{array}` Data for the column to be ordering upon
	 *
	 *  @type array
	 *
	 *  @example
	 *    // Ordering using `input` node values
	 *    $.fn.dataTable.ext.order['dom-text'] = function  ( settings, col )
	 *    {
	 *      return this.api().column( col, {order:'index'} ).nodes().map( function ( td, i ) {
	 *        return $('input', td).val();
	 *      } );
	 *    }
	 */
order:{},type:{className:{},
/**
		 * Type detection functions.
		 *
		 * The functions defined in this object are used to automatically detect
		 * a column's type, making initialisation of DataTables super easy, even
		 * when complex data is in the table.
		 *
		 * The functions defined take two parameters:
		 *
	     *  1. `{*}` Data from the column cell to be analysed
	     *  2. `{settings}` DataTables settings object. This can be used to
	     *     perform context specific type detection - for example detection
	     *     based on language settings such as using a comma for a decimal
	     *     place. Generally speaking the options from the settings will not
	     *     be required
		 *
		 * Each function is expected to return:
		 *
		 * * `{string|null}` Data type detected, or null if unknown (and thus
		 *   pass it on to the other type detection functions.
		 *
		 *  @type array
		 *
		 *  @example
		 *    // Currency type detection plug-in:
		 *    $.fn.dataTable.ext.type.detect.push(
		 *      function ( data, settings ) {
		 *        // Check the numeric part
		 *        if ( ! data.substring(1).match(/[0-9]/) ) {
		 *          return null;
		 *        }
		 *
		 *        // Check prefixed by currency
		 *        if ( data.charAt(0) == '$' || data.charAt(0) == '&pound;' ) {
		 *          return 'currency';
		 *        }
		 *        return null;
		 *      }
		 *    );
		 */
detect:[],render:{},
/**
		 * Type based search formatting.
		 *
		 * The type based searching functions can be used to pre-format the
		 * data to be search on. For example, it can be used to strip HTML
		 * tags or to de-format telephone numbers for numeric only searching.
		 *
		 * Note that is a search is not defined for a column of a given type,
		 * no search formatting will be performed.
		 * 
		 * Pre-processing of searching data plug-ins - When you assign the sType
		 * for a column (or have it automatically detected for you by DataTables
		 * or a type detection plug-in), you will typically be using this for
		 * custom sorting, but it can also be used to provide custom searching
		 * by allowing you to pre-processing the data and returning the data in
		 * the format that should be searched upon. This is done by adding
		 * functions this object with a parameter name which matches the sType
		 * for that target column. This is the corollary of <i>afnSortData</i>
		 * for searching data.
		 *
		 * The functions defined take a single parameter:
		 *
	     *  1. `{*}` Data from the column cell to be prepared for searching
		 *
		 * Each function is expected to return:
		 *
		 * * `{string|null}` Formatted string that will be used for the searching.
		 *
		 *  @type object
		 *  @default {}
		 *
		 *  @example
		 *    $.fn.dataTable.ext.type.search['title-numeric'] = function ( d ) {
		 *      return d.replace(/\n/g," ").replace( /<.*?>/g, "" );
		 *    }
		 */
search:{},
/**
		 * Type based ordering.
		 *
		 * The column type tells DataTables what ordering to apply to the table
		 * when a column is sorted upon. The order for each type that is defined,
		 * is defined by the functions available in this object.
		 *
		 * Each ordering option can be described by three properties added to
		 * this object:
		 *
		 * * `{type}-pre` - Pre-formatting function
		 * * `{type}-asc` - Ascending order function
		 * * `{type}-desc` - Descending order function
		 *
		 * All three can be used together, only `{type}-pre` or only
		 * `{type}-asc` and `{type}-desc` together. It is generally recommended
		 * that only `{type}-pre` is used, as this provides the optimal
		 * implementation in terms of speed, although the others are provided
		 * for compatibility with existing Javascript sort functions.
		 *
		 * `{type}-pre`: Functions defined take a single parameter:
		 *
	     *  1. `{*}` Data from the column cell to be prepared for ordering
		 *
		 * And return:
		 *
		 * * `{*}` Data to be sorted upon
		 *
		 * `{type}-asc` and `{type}-desc`: Functions are typical Javascript sort
		 * functions, taking two parameters:
		 *
	     *  1. `{*}` Data to compare to the second parameter
	     *  2. `{*}` Data to compare to the first parameter
		 *
		 * And returning:
		 *
		 * * `{*}` Ordering match: <0 if first parameter should be sorted lower
		 *   than the second parameter, ===0 if the two parameters are equal and
		 *   >0 if the first parameter should be sorted height than the second
		 *   parameter.
		 * 
		 *  @type object
		 *  @default {}
		 *
		 *  @example
		 *    // Numeric ordering of formatted numbers with a pre-formatter
		 *    $.extend( $.fn.dataTable.ext.type.order, {
		 *      "string-pre": function(x) {
		 *        a = (a === "-" || a === "") ? 0 : a.replace( /[^\d\-\.]/g, "" );
		 *        return parseFloat( a );
		 *      }
		 *    } );
		 *
		 *  @example
		 *    // Case-sensitive string ordering, with no pre-formatting method
		 *    $.extend( $.fn.dataTable.ext.order, {
		 *      "string-case-asc": function(x,y) {
		 *        return ((x < y) ? -1 : ((x > y) ? 1 : 0));
		 *      },
		 *      "string-case-desc": function(x,y) {
		 *        return ((x < y) ? 1 : ((x > y) ? -1 : 0));
		 *      }
		 *    } );
		 */
order:{}},
/**
	 * Unique DataTables instance counter
	 *
	 * @type int
	 * @private
	 */
_unique:0,
/**
	 * Version check function.
	 *  @type function
	 *  @depreciated Since 1.10
	 */
fnVersionCheck:DataTable.fnVersionCheck,
/**
	 * Index for what 'this' index API functions should use
	 *  @type int
	 *  @deprecated Since v1.10
	 */
iApiIndex:0,
/**
	 * Software version
	 *  @type string
	 *  @deprecated Since v1.10
	 */
sVersion:DataTable.version};t.extend(r,{afnFiltering:r.search,aTypes:r.type.detect,ofnSearch:r.type.search,oSort:r.type.order,afnSortData:r.order,aoFeatures:r.feature,oStdClasses:r.classes,oPagination:r.pager});t.extend(DataTable.ext.classes,{container:"dt-container",empty:{row:"dt-empty"},info:{container:"dt-info"},layout:{row:"dt-layout-row",cell:"dt-layout-cell",tableRow:"dt-layout-table",tableCell:"",start:"dt-layout-start",end:"dt-layout-end",full:"dt-layout-full"},length:{container:"dt-length",select:"dt-input"},order:{canAsc:"dt-orderable-asc",canDesc:"dt-orderable-desc",isAsc:"dt-ordering-asc",isDesc:"dt-ordering-desc",none:"dt-orderable-none",position:"sorting_"},processing:{container:"dt-processing"},scrolling:{body:"dt-scroll-body",container:"dt-scroll",footer:{self:"dt-scroll-foot",inner:"dt-scroll-footInner"},header:{self:"dt-scroll-head",inner:"dt-scroll-headInner"}},search:{container:"dt-search",input:"dt-input"},table:"dataTable",tbody:{cell:"",row:""},thead:{cell:"",row:""},tfoot:{cell:"",row:""},paging:{active:"current",button:"dt-paging-button",container:"dt-paging",disabled:"disabled",nav:""}});var r;var n;var i;var o;var l={};var s=/[\r\n\u2028]/g;var u=/<([^>]*>)/g;var f=Math.pow(2,28);var c=/^\d{2,4}[./-]\d{1,2}[./-]\d{1,2}([T ]{1}\d{1,2}[:.]\d{2}([.:]\d{2})?)?$/;var d=new RegExp("(\\"+["/",".","*","+","?","|","(",")","[","]","{","}","\\","$","^","-"].join("|\\")+")","g");var p=/['\u00A0,$£€¥%\u2009\u202F\u20BD\u20a9\u20BArfkɃΞ]/gi;var _empty=function(e){return!e||e===true||e==="-"};var _intVal=function(e){var t=parseInt(e,10);return!isNaN(t)&&isFinite(e)?t:null};var _numToDecimal=function(e,t){l[t]||(l[t]=new RegExp(_(t),"g"));return typeof e==="string"&&t!=="."?e.replace(/\./g,"").replace(l[t],"."):e};var _isNumber=function(e,t,r,n){var i=typeof e;var o=i==="string";if(i==="number"||i==="bigint")return true;if(n&&_empty(e))return true;t&&o&&(e=_numToDecimal(e,t));r&&o&&(e=e.replace(p,""));return!isNaN(parseFloat(e))&&isFinite(e)};var _isHtml=function(e){return _empty(e)||typeof e==="string"};var _htmlNumeric=function(e,t,r,n){if(n&&_empty(e))return true;if(typeof e==="string"&&e.match(/<(input|select)/i))return null;var i=_isHtml(e);return i&&!!_isNumber(_stripHtml(e),t,r,n)||null};var _pluck=function(e,t,r){var n=[];var i=0,o=e.length;if(r!==void 0)for(;i<o;i++)e[i]&&e[i][t]&&n.push(e[i][t][r]);else for(;i<o;i++)e[i]&&n.push(e[i][t]);return n};var _pluck_order=function(e,t,r,n){var i=[];var o=0,l=t.length;if(n!==void 0)for(;o<l;o++)e[t[o]]&&e[t[o]][r]&&i.push(e[t[o]][r][n]);else for(;o<l;o++)e[t[o]]&&i.push(e[t[o]][r]);return i};var _range=function(e,t){var r=[];var n;if(t===void 0){t=0;n=e}else{n=t;t=e}for(var i=t;i<n;i++)r.push(i);return r};var _removeEmpty=function(e){var t=[];for(var r=0,n=e.length;r<n;r++)e[r]&&t.push(e[r]);return t};var _stripHtml=function(e){if(!e||typeof e!=="string")return e;if(e.length>f)throw new Error("Exceeded max str len");var t;e=e.replace(u,"");do{t=e;e=e.replace(/<script/i,"")}while(e!==t);return t};var _escapeHtml=function(e){Array.isArray(e)&&(e=e.join(","));return typeof e==="string"?e.replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;").replace(/"/g,"&quot;"):e};var _normalize=function(e,t){if(typeof e!=="string")return e;var r=e.normalize?e.normalize("NFD"):e;return r.length!==e.length?(t===true?e+" ":"")+r.replace(/[\u0300-\u036f]/g,""):r};
/**
 * Determine if all values in the array are unique. This means we can short
 * cut the _unique method at the cost of a single loop. A sorted array is used
 * to easily check the values.
 *
 * @param  {array} src Source array
 * @return {boolean} true if all unique, false otherwise
 * @ignore
 */var _areAllUnique=function(e){if(e.length<2)return true;var t=e.slice().sort();var r=t[0];for(var n=1,i=t.length;n<i;n++){if(t[n]===r)return false;r=t[n]}return true};
/**
 * Find the unique elements in a source array.
 *
 * @param  {array} src Source array
 * @return {array} Array of unique items
 * @ignore
 */var _unique=function(e){if(Array.from&&Set)return Array.from(new Set(e));if(_areAllUnique(e))return e.slice();var t,r,n,i=[],o=e.length,l=0;e:for(r=0;r<o;r++){t=e[r];for(n=0;n<l;n++)if(i[n]===t)continue e;i.push(t);l++}return i};var _flatten=function(e,t){if(Array.isArray(t))for(var r=0;r<t.length;r++)_flatten(e,t[r]);else e.push(t);return e};function _addClass(e,t){t&&t.split(" ").forEach((function(t){t&&e.classList.add(t)}))}DataTable.util={
/**
	 * Return a string with diacritic characters decomposed
	 * @param {*} mixed Function or string to normalize
	 * @param {*} both Return original string and the normalized string
	 * @returns String or undefined
	 */
diacritics:function(e,t){var r=typeof e;if(r!=="function")return _normalize(e,t);_normalize=e},
/**
	 * Debounce a function
	 *
	 * @param {function} fn Function to be called
	 * @param {integer} freq Call frequency in mS
	 * @return {function} Wrapped function
	 */
debounce:function(e,t){var r;return function(){var n=this;var i=arguments;clearTimeout(r);r=setTimeout((function(){e.apply(n,i)}),t||250)}},
/**
	 * Throttle the calls to a function. Arguments and context are maintained
	 * for the throttled function.
	 *
	 * @param {function} fn Function to be called
	 * @param {integer} freq Call frequency in mS
	 * @return {function} Wrapped function
	 */
throttle:function(e,t){var r,n,i=t!==void 0?t:200;return function(){var t=this,o=+new Date,l=arguments;if(r&&o<r+i){clearTimeout(n);n=setTimeout((function(){r=void 0;e.apply(t,l)}),i)}else{r=o;e.apply(t,l)}}},
/**
	 * Escape a string such that it can be used in a regular expression
	 *
	 *  @param {string} val string to escape
	 *  @returns {string} escaped string
	 */
escapeRegex:function(e){return e.replace(d,"\\$1")},
/**
	 * Create a function that will write to a nested object or array
	 * @param {*} source JSON notation string
	 * @returns Write function
	 */
set:function(e){if(t.isPlainObject(e))return DataTable.util.set(e._);if(e===null)return function(){};if(typeof e==="function")return function(t,r,n){e(t,"set",r,n)};if(typeof e!=="string"||e.indexOf(".")===-1&&e.indexOf("[")===-1&&e.indexOf("(")===-1)return function(t,r){t[e]=r};var setData=function(e,t,r){var n,i=_fnSplitObjNotation(r);var o=i[i.length-1];var l,s,u,f;for(var c=0,d=i.length-1;c<d;c++){if(i[c]==="__proto__"||i[c]==="constructor")throw new Error("Cannot set prototype values");l=i[c].match(v);s=i[c].match(h);if(l){i[c]=i[c].replace(v,"");e[i[c]]=[];n=i.slice();n.splice(0,c+1);f=n.join(".");if(Array.isArray(t))for(var p=0,g=t.length;p<g;p++){u={};setData(u,t[p],f);e[i[c]].push(u)}else e[i[c]]=t;return}if(s){i[c]=i[c].replace(h,"");e=e[i[c]](t)}e[i[c]]!==null&&e[i[c]]!==void 0||(e[i[c]]={});e=e[i[c]]}o.match(h)?e=e[o.replace(h,"")](t):e[o.replace(v,"")]=t};return function(t,r){return setData(t,r,e)}},
/**
	 * Create a function that will read nested objects from arrays, based on JSON notation
	 * @param {*} source JSON notation string
	 * @returns Value read
	 */
get:function(e){if(t.isPlainObject(e)){var r={};t.each(e,(function(e,t){t&&(r[e]=DataTable.util.get(t))}));return function(e,t,n,i){var o=r[t]||r._;return o!==void 0?o(e,t,n,i):e}}if(e===null)return function(e){return e};if(typeof e==="function")return function(t,r,n,i){return e(t,r,n,i)};if(typeof e!=="string"||e.indexOf(".")===-1&&e.indexOf("[")===-1&&e.indexOf("(")===-1)return function(t){return t[e]};var fetchData=function(e,t,r){var n,i,o,l;if(r!==""){var s=_fnSplitObjNotation(r);for(var u=0,f=s.length;u<f;u++){n=s[u].match(v);i=s[u].match(h);if(n){s[u]=s[u].replace(v,"");s[u]!==""&&(e=e[s[u]]);o=[];s.splice(0,u+1);l=s.join(".");if(Array.isArray(e))for(var c=0,d=e.length;c<d;c++)o.push(fetchData(e[c],t,l));var p=n[0].substring(1,n[0].length-1);e=p===""?o:o.join(p);break}if(i){s[u]=s[u].replace(h,"");e=e[s[u]]()}else{if(e===null||e[s[u]]===null)return null;if(e===void 0||e[s[u]]===void 0)return;e=e[s[u]]}}}return e};return function(t,r){return fetchData(t,r,e)}},stripHtml:function(e){var t=typeof e;if(t!=="function")return t==="string"?_stripHtml(e):e;_stripHtml=e},escapeHtml:function(e){var t=typeof e;if(t!=="function")return t==="string"||Array.isArray(e)?_escapeHtml(e):e;_escapeHtml=e},unique:_unique};
/**
 * Create a mapping object that allows camel case parameters to be looked up
 * for their Hungarian counterparts. The mapping is stored in a private
 * parameter called `_hungarianMap` which can be accessed on the source object.
 *  @param {object} o
 *  @memberof DataTable#oApi
 */function _fnHungarianMap(e){var r,n,i="a aa ai ao as b fn i m o s ",o={};t.each(e,(function(t){r=t.match(/^([^A-Z]+?)([A-Z])/);if(r&&i.indexOf(r[1]+" ")!==-1){n=t.replace(r[0],r[2].toLowerCase());o[n]=t;r[1]==="o"&&_fnHungarianMap(e[t])}}));e._hungarianMap=o}
/**
 * Convert from camel case parameters to Hungarian, based on a Hungarian map
 * created by _fnHungarianMap.
 *  @param {object} src The model object which holds all parameters that can be
 *    mapped.
 *  @param {object} user The object to convert from camel case to Hungarian.
 *  @param {boolean} force When set to `true`, properties which already have a
 *    Hungarian value in the `user` object will be overwritten. Otherwise they
 *    won't be.
 *  @memberof DataTable#oApi
 */function _fnCamelToHungarian(e,r,n){e._hungarianMap||_fnHungarianMap(e);var i;t.each(r,(function(o){i=e._hungarianMap[o];if(i!==void 0&&(n||r[i]===void 0))if(i.charAt(0)==="o"){r[i]||(r[i]={});t.extend(true,r[i],r[o]);_fnCamelToHungarian(e[i],r[i],n)}else r[i]=r[o]}))}
/**
 * Map one parameter onto another
 *  @param {object} o Object to map
 *  @param {*} knew The new parameter name
 *  @param {*} old The old parameter name
 */var _fnCompatMap=function(e,t,r){e[t]!==void 0&&(e[r]=e[t])};
/**
 * Provide backwards compatibility for the main DT options. Note that the new
 * options are mapped onto the old parameters, so this is an external interface
 * change only.
 *  @param {object} init Object to map
 */function _fnCompatOpts(e){_fnCompatMap(e,"ordering","bSort");_fnCompatMap(e,"orderMulti","bSortMulti");_fnCompatMap(e,"orderClasses","bSortClasses");_fnCompatMap(e,"orderCellsTop","bSortCellsTop");_fnCompatMap(e,"order","aaSorting");_fnCompatMap(e,"orderFixed","aaSortingFixed");_fnCompatMap(e,"paging","bPaginate");_fnCompatMap(e,"pagingType","sPaginationType");_fnCompatMap(e,"pageLength","iDisplayLength");_fnCompatMap(e,"searching","bFilter");typeof e.sScrollX==="boolean"&&(e.sScrollX=e.sScrollX?"100%":"");typeof e.scrollX==="boolean"&&(e.scrollX=e.scrollX?"100%":"");var t=e.aoSearchCols;if(t)for(var r=0,n=t.length;r<n;r++)t[r]&&_fnCamelToHungarian(DataTable.models.oSearch,t[r]);e.serverSide&&!e.searchDelay&&(e.searchDelay=400)}
/**
 * Provide backwards compatibility for column options. Note that the new options
 * are mapped onto the old parameters, so this is an external interface change
 * only.
 *  @param {object} init Object to map
 */function _fnCompatCols(e){_fnCompatMap(e,"orderable","bSortable");_fnCompatMap(e,"orderData","aDataSort");_fnCompatMap(e,"orderSequence","asSorting");_fnCompatMap(e,"orderDataType","sortDataType");var t=e.aDataSort;typeof t!=="number"||Array.isArray(t)||(e.aDataSort=[t])}
/**
 * Browser feature detection for capabilities, quirks
 *  @param {object} settings dataTables settings object
 *  @memberof DataTable#oApi
 */function _fnBrowserDetect(e){if(!DataTable.__browser){var r={};DataTable.__browser=r;var n=t("<div/>").css({position:"fixed",top:0,left:-1*window.pageXOffset,height:1,width:1,overflow:"hidden"}).append(t("<div/>").css({position:"absolute",top:1,left:1,width:100,overflow:"scroll"}).append(t("<div/>").css({width:"100%",height:10}))).appendTo("body");var i=n.children();var o=i.children();r.barWidth=i[0].offsetWidth-i[0].clientWidth;r.bScrollbarLeft=Math.round(o.offset().left)!==1;n.remove()}t.extend(e.oBrowser,DataTable.__browser);e.oScroll.iBarWidth=DataTable.__browser.barWidth}
/**
 * Add a column to the list used for the table with default values
 *  @param {object} oSettings dataTables settings object
 *  @memberof DataTable#oApi
 */function _fnAddColumn(e){var r=DataTable.defaults.column;var n=e.aoColumns.length;var i=t.extend({},DataTable.models.oColumn,r,{aDataSort:r.aDataSort?r.aDataSort:[n],mData:r.mData?r.mData:n,idx:n,searchFixed:{},colEl:t("<col>").attr("data-dt-column",n)});e.aoColumns.push(i);var o=e.aoPreSearchCols;o[n]=t.extend({},DataTable.models.oSearch,o[n])}
/**
 * Apply options for a column
 *  @param {object} oSettings dataTables settings object
 *  @param {int} iCol column index to consider
 *  @param {object} oOptions object with sType, bVisible and bSearchable etc
 *  @memberof DataTable#oApi
 */function _fnColumnOptions(e,r,n){var i=e.aoColumns[r];if(n!==void 0&&n!==null){_fnCompatCols(n);_fnCamelToHungarian(DataTable.defaults.column,n,true);n.mDataProp===void 0||n.mData||(n.mData=n.mDataProp);n.sType&&(i._sManualType=n.sType);n.className&&!n.sClass&&(n.sClass=n.className);var o=i.sClass;t.extend(i,n);_fnMap(i,n,"sWidth","sWidthOrig");o!==i.sClass&&(i.sClass=o+" "+i.sClass);n.iDataSort!==void 0&&(i.aDataSort=[n.iDataSort]);_fnMap(i,n,"aDataSort")}var l=i.mData;var s=g(l);if(i.mRender&&Array.isArray(i.mRender)){var u=i.mRender.slice();var f=u.shift();i.mRender=DataTable.render[f].apply(window,u)}i._render=i.mRender?g(i.mRender):null;var attrTest=function(e){return typeof e==="string"&&e.indexOf("@")!==-1};i._bAttrSrc=t.isPlainObject(l)&&(attrTest(l.sort)||attrTest(l.type)||attrTest(l.filter));i._setter=null;i.fnGetData=function(e,t,r){var n=s(e,t,void 0,r);return i._render&&t?i._render(n,t,e,r):n};i.fnSetData=function(e,t,r){return m(l)(e,t,r)};typeof l==="number"||i._isArrayHost||(e._rowReadObject=true);e.oFeatures.bSort||(i.bSortable=false)}
/**
 * Adjust the table column widths for new data. Note: you would probably want to
 * do a redraw after calling this function!
 *  @param {object} settings dataTables settings object
 *  @memberof DataTable#oApi
 */function _fnAdjustColumnSizing(e){_fnCalculateColumnWidths(e);_fnColumnSizes(e);var t=e.oScroll;t.sY===""&&t.sX===""||_fnScrollDraw(e);_fnCallbackFire(e,null,"column-sizing",[e])}
/**
 * Apply column sizes
 *
 * @param {*} settings DataTables settings object
 */function _fnColumnSizes(e){var t=e.aoColumns;for(var r=0;r<t.length;r++){var n=_fnColumnsSumWidth(e,[r],false,false);t[r].colEl.css("width",n);e.oScroll.sX&&t[r].colEl.css("min-width",n)}}
/**
 * Convert the index of a visible column to the index in the data array (take account
 * of hidden columns)
 *  @param {object} oSettings dataTables settings object
 *  @param {int} iMatch Visible column index to lookup
 *  @returns {int} i the data index
 *  @memberof DataTable#oApi
 */function _fnVisibleToColumnIndex(e,t){var r=_fnGetColumns(e,"bVisible");return typeof r[t]==="number"?r[t]:null}
/**
 * Convert the index of an index in the data array and convert it to the visible
 *   column index (take account of hidden columns)
 *  @param {int} iMatch Column index to lookup
 *  @param {object} oSettings dataTables settings object
 *  @returns {int} i the data index
 *  @memberof DataTable#oApi
 */function _fnColumnIndexToVisible(e,t){var r=_fnGetColumns(e,"bVisible");var n=r.indexOf(t);return n!==-1?n:null}
/**
 * Get the number of visible columns
 *  @param {object} oSettings dataTables settings object
 *  @returns {int} i the number of visible columns
 *  @memberof DataTable#oApi
 */function _fnVisbleColumns(e){var r=e.aoHeader;var n=e.aoColumns;var i=0;if(r.length)for(var o=0,l=r[0].length;o<l;o++)n[o].bVisible&&t(r[0][o].cell).css("display")!=="none"&&i++;return i}
/**
 * Get an array of column indexes that match a given property
 *  @param {object} oSettings dataTables settings object
 *  @param {string} sParam Parameter in aoColumns to look for - typically
 *    bVisible or bSearchable
 *  @returns {array} Array of indexes with matched properties
 *  @memberof DataTable#oApi
 */function _fnGetColumns(e,t){var r=[];e.aoColumns.map((function(e,n){e[t]&&r.push(n)}));return r}
/**
 * Allow the result from a type detection function to be `true` while
 * translating that into a string. Old type detection functions will
 * return the type name if it passes. An obect store would be better,
 * but not backwards compatible.
 *
 * @param {*} typeDetect Object or function for type detection
 * @param {*} res Result from the type detection function
 * @returns Type name or false
 */function _typeResult(e,t){return t===true?e._name:t}
/**
 * Calculate the 'type' of a column
 *  @param {object} settings dataTables settings object
 *  @memberof DataTable#oApi
 */function _fnColumnTypes(e){var t=e.aoColumns;var n=e.aoData;var i=DataTable.ext.type.detect;var o,l,s,u,f,c;var d,p,v;for(o=0,l=t.length;o<l;o++){d=t[o];v=[];if(!d.sType&&d._sManualType)d.sType=d._sManualType;else if(!d.sType){if(!e.typeDetect)return;for(s=0,u=i.length;s<u;s++){var h=i[s];var g=h.oneOf;var m=h.allOf||h;var _=h.init;var b=false;p=null;if(_){p=_typeResult(h,_(e,d,o));if(p){d.sType=p;break}}for(f=0,c=n.length;f<c;f++)if(n[f]){v[f]===void 0&&(v[f]=_fnGetCellData(e,f,o,"type"));g&&!b&&(b=_typeResult(h,g(v[f],e)));p=_typeResult(h,m(v[f],e));if(!p&&s!==i.length-3)break;if(p==="html"&&!_empty(v[f]))break}if(g&&b&&p||!g&&p){d.sType=p;break}}d.sType||(d.sType="string")}var y=r.type.className[d.sType];if(y){_columnAutoClass(e.aoHeader,o,y);_columnAutoClass(e.aoFooter,o,y)}var D=r.type.render[d.sType];if(D&&!d._render){d._render=DataTable.util.get(D);_columnAutoRender(e,o)}}}function _columnAutoRender(e,t){var r=e.aoData;for(var n=0;n<r.length;n++)if(r[n].nTr){var i=_fnGetCellData(e,n,t,"display");r[n].displayData[t]=i;_fnWriteCell(r[n].anCells[t],i)}}function _columnAutoClass(e,t,r){e.forEach((function(e){e[t]&&e[t].unique&&_addClass(e[t].cell,r)}))}
/**
 * Take the column definitions and static columns arrays and calculate how
 * they relate to column indexes. The callback function will then apply the
 * definition found for a column to a suitable configuration object.
 *  @param {object} oSettings dataTables settings object
 *  @param {array} aoColDefs The aoColumnDefs array that is to be applied
 *  @param {array} aoCols The aoColumns array that defines columns individually
 *  @param {array} headerLayout Layout for header as it was loaded
 *  @param {function} fn Callback function - takes two parameters, the calculated
 *    column index and the definition for that column.
 *  @memberof DataTable#oApi
 */function _fnApplyColumnDefs(e,r,n,i,o){var l,s,u,f,c,d,p;var v=e.aoColumns;if(n)for(l=0,s=n.length;l<s;l++)n[l]&&n[l].name&&(v[l].sName=n[l].name);if(r)for(l=r.length-1;l>=0;l--){p=r[l];var h=p.target!==void 0?p.target:p.targets!==void 0?p.targets:p.aTargets;Array.isArray(h)||(h=[h]);for(u=0,f=h.length;u<f;u++){var g=h[u];if(typeof g==="number"&&g>=0){while(v.length<=g)_fnAddColumn(e);o(g,p)}else if(typeof g==="number"&&g<0)o(v.length+g,p);else if(typeof g==="string")for(c=0,d=v.length;c<d;c++)g==="_all"?o(c,p):g.indexOf(":name")!==-1?v[c].sName===g.replace(":name","")&&o(c,p):i.forEach((function(e){if(e[c]){var r=t(e[c].cell);g.match(/^[a-z][\w-]*$/i)&&(g="."+g);r.is(g)&&o(c,p)}}))}}if(n)for(l=0,s=n.length;l<s;l++)o(l,n[l])}
/**
 * Get the width for a given set of columns
 *
 * @param {*} settings DataTables settings object
 * @param {*} targets Columns - comma separated string or array of numbers
 * @param {*} original Use the original width (true) or calculated (false)
 * @param {*} incVisible Include visible columns (true) or not (false)
 * @returns Combined CSS value
 */function _fnColumnsSumWidth(e,t,r,n){Array.isArray(t)||(t=_fnColumnsFromHeader(t));var i=0;var o;var l=e.aoColumns;for(var s=0,u=t.length;s<u;s++){var f=l[t[s]];var c=r?f.sWidthOrig:f.sWidth;if(n||f.bVisible!==false){if(c===null||c===void 0)return null;if(typeof c==="number"){o="px";i+=c}else{var d=c.match(/([\d\.]+)([^\d]*)/);if(d){i+=d[1]*1;o=d.length===3?d[2]:"px"}}}}return i+o}function _fnColumnsFromHeader(e){var r=t(e).closest("[data-dt-column]").attr("data-dt-column");return r?r.split(",").map((function(e){return e*1})):[]}
/**
 * Add a data array to the table, creating DOM node etc. This is the parallel to
 * _fnGatherData, but for adding rows from a Javascript source, rather than a
 * DOM source.
 *  @param {object} settings dataTables settings object
 *  @param {array} data data array to be added
 *  @param {node} [tr] TR element to add to the table - optional. If not given,
 *    DataTables will create a row automatically
 *  @param {array} [tds] Array of TD|TH elements for the row - must be given
 *    if nTr is.
 *  @returns {int} >=0 if successful (index of new aoData entry), -1 if failed
 *  @memberof DataTable#oApi
 */function _fnAddData(e,r,n,i){var o=e.aoData.length;var l=t.extend(true,{},DataTable.models.oRow,{src:n?"dom":"data",idx:o});l._aData=r;e.aoData.push(l);var s=e.aoColumns;for(var u=0,f=s.length;u<f;u++)s[u].sType=null;e.aiDisplayMaster.push(o);var c=e.rowIdFn(r);c!==void 0&&(e.aIds[c]=l);!n&&e.oFeatures.bDeferRender||_fnCreateTr(e,o,n,i);return o}
/**
 * Add one or more TR elements to the table. Generally we'd expect to
 * use this for reading data from a DOM sourced table, but it could be
 * used for an TR element. Note that if a TR is given, it is used (i.e.
 * it is not cloned).
 *  @param {object} settings dataTables settings object
 *  @param {array|node|jQuery} trs The TR element(s) to add to the table
 *  @returns {array} Array of indexes for the added rows
 *  @memberof DataTable#oApi
 */function _fnAddTr(e,r){var n;r instanceof t||(r=t(r));return r.map((function(t,r){n=_fnGetRowElements(e,r);return _fnAddData(e,n.data,r,n.cells)}))}
/**
 * Get the data for a given cell from the internal cache, taking into account data mapping
 *  @param {object} settings dataTables settings object
 *  @param {int} rowIdx aoData row id
 *  @param {int} colIdx Column index
 *  @param {string} type data get type ('display', 'type' 'filter|search' 'sort|order')
 *  @returns {*} Cell data
 *  @memberof DataTable#oApi
 */function _fnGetCellData(e,t,r,n){n==="search"?n="filter":n==="order"&&(n="sort");var i=e.aoData[t];if(i){var o=e.iDraw;var l=e.aoColumns[r];var s=i._aData;var u=l.sDefaultContent;var f=l.fnGetData(s,n,{settings:e,row:t,col:r});n!=="display"&&f&&typeof f==="object"&&f.nodeName&&(f=f.innerHTML);if(f===void 0){if(e.iDrawError!=o&&u===null){_fnLog(e,0,"Requested unknown parameter "+(typeof l.mData=="function"?"{function}":"'"+l.mData+"'")+" for row "+t+", column "+r,4);e.iDrawError=o}return u}if(f!==s&&f!==null||u===null||n===void 0){if(typeof f==="function")return f.call(s)}else f=u;if(f===null&&n==="display")return"";if(n==="filter"){var c=DataTable.ext.type.search;c[l.sType]&&(f=c[l.sType](f))}return f}}
/**
 * Set the value for a specific cell, into the internal data cache
 *  @param {object} settings dataTables settings object
 *  @param {int} rowIdx aoData row id
 *  @param {int} colIdx Column index
 *  @param {*} val Value to set
 *  @memberof DataTable#oApi
 */function _fnSetCellData(e,t,r,n){var i=e.aoColumns[r];var o=e.aoData[t]._aData;i.fnSetData(o,n,{settings:e,row:t,col:r})}
/**
 * Write a value to a cell
 * @param {*} td Cell
 * @param {*} val Value
 */function _fnWriteCell(e,r){r&&typeof r==="object"&&r.nodeName?t(e).empty().append(r):e.innerHTML=r}var v=/\[.*?\]$/;var h=/\(\)$/;
/**
 * Split string on periods, taking into account escaped periods
 * @param  {string} str String to split
 * @return {array} Split string
 */function _fnSplitObjNotation(e){var t=e.match(/(\\.|[^.])+/g)||[""];return t.map((function(e){return e.replace(/\\\./g,".")}))}
/**
 * Return a function that can be used to get data from a source object, taking
 * into account the ability to use nested objects as a source
 *  @param {string|int|function} mSource The data source for the object
 *  @returns {function} Data get function
 *  @memberof DataTable#oApi
 */var g=DataTable.util.get;
/**
 * Return a function that can be used to set data from a source object, taking
 * into account the ability to use nested objects as a source
 *  @param {string|int|function} mSource The data source for the object
 *  @returns {function} Data set function
 *  @memberof DataTable#oApi
 */var m=DataTable.util.set;
/**
 * Return an array with the full table data
 *  @param {object} oSettings dataTables settings object
 *  @returns array {array} aData Master data array
 *  @memberof DataTable#oApi
 */function _fnGetDataMaster(e){return _pluck(e.aoData,"_aData")}
/**
 * Nuke the table
 *  @param {object} oSettings dataTables settings object
 *  @memberof DataTable#oApi
 */function _fnClearTable(e){e.aoData.length=0;e.aiDisplayMaster.length=0;e.aiDisplay.length=0;e.aIds={}}
/**
 * Mark cached data as invalid such that a re-read of the data will occur when
 * the cached data is next requested. Also update from the data source object.
 *
 * @param {object} settings DataTables settings object
 * @param {int}    rowIdx   Row index to invalidate
 * @param {string} [src]    Source to invalidate from: undefined, 'auto', 'dom'
 *     or 'data'
 * @param {int}    [colIdx] Column index to invalidate. If undefined the whole
 *     row will be invalidated
 * @memberof DataTable#oApi
 *
 * @todo For the modularisation of v1.11 this will need to become a callback, so
 *   the sort and filter methods can subscribe to it. That will required
 *   initialisation options for sorting, which is why it is not already baked in
 */function _fnInvalidate(e,t,r,n){var i=e.aoData[t];var o,l;i._aSortData=null;i._aFilterData=null;i.displayData=null;if(r!=="dom"&&(r&&r!=="auto"||i.src!=="dom")){var s=i.anCells;var u=_fnGetRowDisplay(e,t);if(s)if(n!==void 0)_fnWriteCell(s[n],u[n]);else for(o=0,l=s.length;o<l;o++)_fnWriteCell(s[o],u[o])}else i._aData=_fnGetRowElements(e,i,n,n===void 0?void 0:i._aData).data;var f=e.aoColumns;if(n!==void 0){f[n].sType=null;f[n].maxLenString=null}else{for(o=0,l=f.length;o<l;o++){f[o].sType=null;f[o].maxLenString=null}_fnRowAttributes(e,i)}}
/**
 * Build a data source object from an HTML row, reading the contents of the
 * cells that are in the row.
 *
 * @param {object} settings DataTables settings object
 * @param {node|object} TR element from which to read data or existing row
 *   object from which to re-read the data from the cells
 * @param {int} [colIdx] Optional column index
 * @param {array|object} [d] Data source object. If `colIdx` is given then this
 *   parameter should also be given and will be used to write the data into.
 *   Only the column in question will be written
 * @returns {object} Object with two parameters: `data` the data read, in
 *   document order, and `cells` and array of nodes (they can be useful to the
 *   caller, so rather than needing a second traversal to get them, just return
 *   them from here).
 * @memberof DataTable#oApi
 */function _fnGetRowElements(e,t,r,n){var i,o,l,s=[],u=t.firstChild,f=0,c=e.aoColumns,d=e._rowReadObject;n=n!==void 0?n:d?{}:[];var attr=function(e,t){if(typeof e==="string"){var r=e.indexOf("@");if(r!==-1){var i=e.substring(r+1);var o=m(e);o(n,t.getAttribute(i))}}};var cellProcess=function(e){if(r===void 0||r===f){o=c[f];l=e.innerHTML.trim();if(o&&o._bAttrSrc){var t=m(o.mData._);t(n,l);attr(o.mData.sort,e);attr(o.mData.type,e);attr(o.mData.filter,e)}else if(d){o._setter||(o._setter=m(o.mData));o._setter(n,l)}else n[f]=l}f++};if(u)while(u){i=u.nodeName.toUpperCase();if(i=="TD"||i=="TH"){cellProcess(u);s.push(u)}u=u.nextSibling}else{s=t.anCells;for(var p=0,v=s.length;p<v;p++)cellProcess(s[p])}var h=t.firstChild?t:t.nTr;if(h){var g=h.getAttribute("id");g&&m(e.rowId)(n,g)}return{data:n,cells:s}}
/**
 * Render and cache a row's display data for the columns, if required
 * @returns 
 */function _fnGetRowDisplay(e,t){var r=e.aoData[t];var n=e.aoColumns;if(!r.displayData){r.displayData=[];for(var i=0,o=n.length;i<o;i++)r.displayData.push(_fnGetCellData(e,t,i,"display"))}return r.displayData}
/**
 * Create a new TR element (and it's TD children) for a row
 *  @param {object} oSettings dataTables settings object
 *  @param {int} iRow Row to consider
 *  @param {node} [nTrIn] TR element to add to the table - optional. If not given,
 *    DataTables will create a row automatically
 *  @param {array} [anTds] Array of TD|TH elements for the row - must be given
 *    if nTr is.
 *  @memberof DataTable#oApi
 */function _fnCreateTr(e,r,n,i){var o,l,s,u,f,c,d=e.aoData[r],p=d._aData,v=[],h=e.oClasses.tbody.row;if(d.nTr===null){o=n||document.createElement("tr");d.nTr=o;d.anCells=v;_addClass(o,h);o._DT_RowIndex=r;_fnRowAttributes(e,d);for(u=0,f=e.aoColumns.length;u<f;u++){s=e.aoColumns[u];c=!n||!i[u];l=c?document.createElement(s.sCellType):i[u];l||_fnLog(e,0,"Incorrect column count",18);l._DT_CellIndex={row:r,column:u};v.push(l);var g=_fnGetRowDisplay(e,r);!c&&(!s.mRender&&s.mData===u||t.isPlainObject(s.mData)&&s.mData._===u+".display")||_fnWriteCell(l,g[u]);_addClass(l,s.sClass);s.bVisible&&c?o.appendChild(l):s.bVisible||c||l.parentNode.removeChild(l);s.fnCreatedCell&&s.fnCreatedCell.call(e.oInstance,l,_fnGetCellData(e,r,u),p,r,u)}_fnCallbackFire(e,"aoRowCreatedCallback","row-created",[o,p,r,v])}else _addClass(d.nTr,h)}
/**
 * Add attributes to a row based on the special `DT_*` parameters in a data
 * source object.
 *  @param {object} settings DataTables settings object
 *  @param {object} DataTables row object for the row to be modified
 *  @memberof DataTable#oApi
 */function _fnRowAttributes(e,r){var n=r.nTr;var i=r._aData;if(n){var o=e.rowIdFn(i);o&&(n.id=o);if(i.DT_RowClass){var l=i.DT_RowClass.split(" ");r.__rowc=r.__rowc?_unique(r.__rowc.concat(l)):l;t(n).removeClass(r.__rowc.join(" ")).addClass(i.DT_RowClass)}i.DT_RowAttr&&t(n).attr(i.DT_RowAttr);i.DT_RowData&&t(n).data(i.DT_RowData)}}
/**
 * Create the HTML header for the table
 *  @param {object} oSettings dataTables settings object
 *  @memberof DataTable#oApi
 */function _fnBuildHead(e,r){var n=e.oClasses;var i=e.aoColumns;var o,l,s;var u=r==="header"?e.nTHead:e.nTFoot;var f=r==="header"?"sTitle":r;if(u){if(r==="header"||_pluck(e.aoColumns,f).join("")){s=t("tr",u);s.length||(s=t("<tr/>").appendTo(u));if(s.length===1){var c=0;t("td, th",s).each((function(){c+=this.colSpan}));for(o=c,l=i.length;o<l;o++)t("<th/>").html(i[o][f]||"").appendTo(s)}}var d=_fnDetectHeader(e,u,true);if(r==="header"){e.aoHeader=d;t("tr",u).addClass(n.thead.row)}else{e.aoFooter=d;t("tr",u).addClass(n.tfoot.row)}t(u).children("tr").children("th, td").each((function(){_fnRenderer(e,r)(e,t(this),n)}))}}
/**
 * Build a layout structure for a header or footer
 *
 * @param {*} settings DataTables settings
 * @param {*} source Source layout array
 * @param {*} incColumns What columns should be included
 * @returns Layout array
 */function _fnHeaderLayout(e,r,n){var i,o,l;var s=[];var u=[];var f=e.aoColumns;var c=f.length;var d,p;if(r){n||(n=_range(c).filter((function(e){return f[e].bVisible})));for(i=0;i<r.length;i++){s[i]=r[i].slice().filter((function(e,t){return n.includes(t)}));u.push([])}for(i=0;i<s.length;i++)for(o=0;o<s[i].length;o++){d=1;p=1;if(u[i][o]===void 0){l=s[i][o].cell;while(s[i+d]!==void 0&&s[i][o].cell==s[i+d][o].cell){u[i+d][o]=null;d++}while(s[i][o+p]!==void 0&&s[i][o].cell==s[i][o+p].cell){for(var v=0;v<d;v++)u[i+v][o+p]=null;p++}var h=t("span.dt-column-title",l);u[i][o]={cell:l,colspan:p,rowspan:d,title:h.length?h.html():t(l).html()}}}return u}}
/**
 * Draw the header (or footer) element based on the column visibility states.
 *
 *  @param object oSettings dataTables settings object
 *  @param array aoSource Layout array from _fnDetectHeader
 *  @memberof DataTable#oApi
 */function _fnDrawHead(e,r){var n=_fnHeaderLayout(e,r);var i,o;for(var l=0;l<r.length;l++){i=r[l].row;if(i)while(o=i.firstChild)i.removeChild(o);for(var s=0;s<n[l].length;s++){var u=n[l][s];u&&t(u.cell).appendTo(i).attr("rowspan",u.rowspan).attr("colspan",u.colspan)}}}
/**
 * Insert the required TR nodes into the table for display
 *  @param {object} oSettings dataTables settings object
 *  @param ajaxComplete true after ajax call to complete rendering
 *  @memberof DataTable#oApi
 */function _fnDraw(e,n){_fnStart(e);var i=_fnCallbackFire(e,"aoPreDrawCallback","preDraw",[e]);if(i.indexOf(false)===-1){var o=[];var l=0;var s=_fnDataSource(e)=="ssp";var u=e.aiDisplay;var f=e._iDisplayStart;var c=e.fnDisplayEnd();var d=e.aoColumns;var p=t(e.nTBody);e.bDrawing=true;if(e.deferLoading){e.deferLoading=false;e.iDraw++;_fnProcessingDisplay(e,false)}else if(s){if(!e.bDestroying&&!n){e.iDraw===0&&p.empty().append(_emptyRow(e));_fnAjaxUpdate(e);return}}else e.iDraw++;if(u.length!==0){var v=s?0:f;var h=s?e.aoData.length:c;for(var g=v;g<h;g++){var m=u[g];var _=e.aoData[m];_.nTr===null&&_fnCreateTr(e,m);var b=_.nTr;for(var y=0;y<d.length;y++){var D=d[y];var C=_.anCells[y];_addClass(C,r.type.className[D.sType]);_addClass(C,e.oClasses.tbody.cell)}_fnCallbackFire(e,"aoRowCallback",null,[b,_._aData,l,g,m]);o.push(b);l++}}else o[0]=_emptyRow(e);_fnCallbackFire(e,"aoHeaderCallback","header",[t(e.nTHead).children("tr")[0],_fnGetDataMaster(e),f,c,u]);_fnCallbackFire(e,"aoFooterCallback","footer",[t(e.nTFoot).children("tr")[0],_fnGetDataMaster(e),f,c,u]);if(p[0].replaceChildren)p[0].replaceChildren.apply(p[0],o);else{p.children().detach();p.append(t(o))}t(e.nTableWrapper).toggleClass("dt-empty-footer",t("tr",e.nTFoot).length===0);_fnCallbackFire(e,"aoDrawCallback","draw",[e],true);e.bSorted=false;e.bFiltered=false;e.bDrawing=false}else _fnProcessingDisplay(e,false)}
/**
 * Redraw the table - taking account of the various features which are enabled
 *  @param {object} oSettings dataTables settings object
 *  @param {boolean} [holdPosition] Keep the current paging position. By default
 *    the paging is reset to the first page
 *  @memberof DataTable#oApi
 */function _fnReDraw(e,t,r){var n=e.oFeatures,i=n.bSort,o=n.bFilter;if(r===void 0||r===true){_fnColumnTypes(e);i&&_fnSort(e);o?_fnFilterComplete(e,e.oPreviousSearch):e.aiDisplay=e.aiDisplayMaster.slice()}t!==true&&(e._iDisplayStart=0);e._drawHold=t;_fnDraw(e);e._drawHold=false}function _emptyRow(e){var r=e.oLanguage;var n=r.sZeroRecords;var i=_fnDataSource(e);e.iDraw<1&&i==="ssp"||e.iDraw<=1&&i==="ajax"?n=r.sLoadingRecords:r.sEmptyTable&&e.fnRecordsTotal()===0&&(n=r.sEmptyTable);return t("<tr/>").append(t("<td />",{colSpan:_fnVisbleColumns(e),class:e.oClasses.empty.row}).html(n))[0]}function _layoutItems(e,r,n){if(Array.isArray(n))for(var i=0;i<n.length;i++)_layoutItems(e,r,n[i]);else{var o=e[r];if(t.isPlainObject(n))if(n.features){n.rowId&&(e.id=n.rowId);n.rowClass&&(e.className=n.rowClass);o.id=n.id;o.className=n.className;_layoutItems(e,r,n.features)}else Object.keys(n).map((function(e){o.contents.push({feature:e,opts:n[e]})}));else o.contents.push(n)}}function _layoutGetRow(e,t,r){var n;for(var i=0;i<e.length;i++){n=e[i];if(n.rowNum===t&&(r==="full"&&n.full||(r==="start"||r==="end")&&(n.start||n.end))){n[r]||(n[r]={contents:[]});return n}}n={rowNum:t};n[r]={contents:[]};e.push(n);return n}
/**
 * Convert a `layout` object given by a user to the object structure needed
 * for the renderer. This is done twice, once for above and once for below
 * the table. Ordering must also be considered.
 *
 * @param {*} settings DataTables settings object
 * @param {*} layout Layout object to convert
 * @param {string} side `top` or `bottom`
 * @returns Converted array structure - one item for each row.
 */function _layoutArray(e,r,n){var i=[];t.each(r,(function(e,t){if(t!==null){var r=e.match(/^([a-z]+)([0-9]*)([A-Za-z]*)$/);var o=r[2]?r[2]*1:0;var l=r[3]?r[3].toLowerCase():"full";if(r[1]===n){var s=_layoutGetRow(i,o,l);_layoutItems(s,l,t)}}}));i.sort((function(e,t){var r=e.rowNum;var i=t.rowNum;if(r===i){var o=e.full&&!t.full?-1:1;return n==="bottom"?o*-1:o}return i-r}));n==="bottom"&&i.reverse();for(var o=0;o<i.length;o++){delete i[o].rowNum;_layoutResolve(e,i[o])}return i}
/**
 * Convert the contents of a row's layout object to nodes that can be inserted
 * into the document by a renderer. Execute functions, look up plug-ins, etc.
 *
 * @param {*} settings DataTables settings object
 * @param {*} row Layout object for this row
 */function _layoutResolve(e,n){var getFeature=function(t,n){r.features[t]||_fnLog(e,0,"Unknown feature: "+t);return r.features[t].apply(this,[e,n])};var resolve=function(r){if(n[r]){var i=n[r].contents;for(var o=0,l=i.length;o<l;o++)if(i[o])if(typeof i[o]==="string")i[o]=getFeature(i[o],null);else if(t.isPlainObject(i[o]))i[o]=getFeature(i[o].feature,i[o].opts);else if(typeof i[o].node==="function")i[o]=i[o].node(e);else if(typeof i[o]==="function"){var s=i[o](e);i[o]=typeof s.node==="function"?s.node():s}}};resolve("start");resolve("end");resolve("full")}
/**
 * Add the options to the page HTML for the table
 *  @param {object} settings DataTables settings object
 *  @memberof DataTable#oApi
 */function _fnAddOptionsHtml(e){var r=e.oClasses;var n=t(e.nTable);var i=t("<div/>").attr({id:e.sTableId+"_wrapper",class:r.container}).insertBefore(n);e.nTableWrapper=i[0];if(e.sDom)_fnLayoutDom(e,e.sDom,i);else{var o=_layoutArray(e,e.layout,"top");var l=_layoutArray(e,e.layout,"bottom");var s=_fnRenderer(e,"layout");o.forEach((function(t){s(e,i,t)}));s(e,i,{full:{table:true,contents:[_fnFeatureHtmlTable(e)]}});l.forEach((function(t){s(e,i,t)}))}_processingHtml(e)}
/**
 * Draw the table with the legacy DOM property
 * @param {*} settings DT settings object
 * @param {*} dom DOM string
 * @param {*} insert Insert point
 */function _fnLayoutDom(e,r,n){var i=r.match(/(".*?")|('.*?')|./g);var o,l,s,u,f;for(var c=0;c<i.length;c++){o=null;l=i[c];if(l=="<"){s=t("<div/>");u=i[c+1];if(u[0]=="'"||u[0]=='"'){f=u.replace(/['"]/g,"");var d,p="";if(f.indexOf(".")!=-1){var v=f.split(".");p=v[0];d=v[1]}else f[0]=="#"?p=f:d=f;s.attr("id",p.substring(1)).addClass(d);c++}n.append(s);n=s}else l==">"?n=n.parent():l=="t"?o=_fnFeatureHtmlTable(e):DataTable.ext.feature.forEach((function(t){l==t.cFeature&&(o=t.fnInit(e))}));o&&n.append(o)}}
/**
 * Use the DOM source to create up an array of header cells. The idea here is to
 * create a layout grid (array) of rows x columns, which contains a reference
 * to the cell that that point in the grid (regardless of col/rowspan), such that
 * any column / row could be removed and the new grid constructed
 *  @param {node} thead The header/footer element for the table
 *  @returns {array} Calculated layout array
 *  @memberof DataTable#oApi
 */function _fnDetectHeader(e,r,n){var i=e.aoColumns;var o=t(r).children("tr");var l,s;var u,f,c,d,p,v,h,g;var m=r&&r.nodeName.toLowerCase()==="thead";var _=[];var b;var shift=function(e,t,r){var n=e[t];while(n[r])r++;return r};for(u=0,d=o.length;u<d;u++)_.push([]);for(u=0,d=o.length;u<d;u++){l=o[u];v=0;s=l.firstChild;while(s){if(s.nodeName.toUpperCase()=="TD"||s.nodeName.toUpperCase()=="TH"){var y=[];h=s.getAttribute("colspan")*1;g=s.getAttribute("rowspan")*1;h=h&&h!==0&&h!==1?h:1;g=g&&g!==0&&g!==1?g:1;p=shift(_,u,v);b=h===1;if(n){if(b){_fnColumnOptions(e,p,t(s).data());var D=i[p];var C=s.getAttribute("width")||null;var S=s.style.width.match(/width:\s*(\d+[pxem%]+)/);S&&(C=S[1]);D.sWidthOrig=D.sWidth||C;if(m){D.sTitle===null||D.autoTitle||(s.innerHTML=D.sTitle);if(!D.sTitle&&b){D.sTitle=_stripHtml(s.innerHTML);D.autoTitle=true}}else D.footer&&(s.innerHTML=D.footer);D.ariaTitle||(D.ariaTitle=t(s).attr("aria-label")||D.sTitle);D.className&&t(s).addClass(D.className)}t("span.dt-column-title",s).length===0&&t("<span>").addClass("dt-column-title").append(s.childNodes).appendTo(s);m&&t("span.dt-column-order",s).length===0&&t("<span>").addClass("dt-column-order").appendTo(s)}for(c=0;c<h;c++){for(f=0;f<g;f++){_[u+f][p+c]={cell:s,unique:b};_[u+f].row=l}y.push(p+c)}s.setAttribute("data-dt-column",_unique(y).join(","))}s=s.nextSibling}}return _}
/**
 * Set the start position for draw
 *  @param {object} oSettings dataTables settings object
 */function _fnStart(e){var t=_fnDataSource(e)=="ssp";var r=e.iInitDisplayStart;if(r!==void 0&&r!==-1){e._iDisplayStart=t?r:r>=e.fnRecordsDisplay()?0:r;e.iInitDisplayStart=-1}}
/**
 * Create an Ajax call based on the table's settings, taking into account that
 * parameters can have multiple forms, and backwards compatibility.
 *
 * @param {object} oSettings dataTables settings object
 * @param {array} data Data to send to the server, required by
 *     DataTables - may be augmented by developer callbacks
 * @param {function} fn Callback function to run when data is obtained
 */function _fnBuildAjax(e,r,n){var i;var o=e.ajax;var l=e.oInstance;var callback=function(t){var r=e.jqXHR?e.jqXHR.status:null;if(t===null||typeof r==="number"&&r==204){t={};_fnAjaxDataSrc(e,t,[])}var i=t.error||t.sError;i&&_fnLog(e,0,i);if(t.d&&typeof t.d==="string")try{t=JSON.parse(t.d)}catch(e){}e.json=t;_fnCallbackFire(e,null,"xhr",[e,t,e.jqXHR],true);n(t)};if(t.isPlainObject(o)&&o.data){i=o.data;var s=typeof i==="function"?i(r,e):i;r=typeof i==="function"&&s?s:t.extend(true,r,s);delete o.data}var u={url:typeof o==="string"?o:"",data:r,success:callback,dataType:"json",cache:false,type:e.sServerMethod,error:function(t,r){var n=_fnCallbackFire(e,null,"xhr",[e,null,e.jqXHR],true);n.indexOf(true)===-1&&(r=="parsererror"?_fnLog(e,0,"Invalid JSON response",1):t.readyState===4&&_fnLog(e,0,"Ajax error",7));_fnProcessingDisplay(e,false)}};t.isPlainObject(o)&&t.extend(u,o);e.oAjaxData=r;_fnCallbackFire(e,null,"preXhr",[e,r,u],true);if(typeof o==="function")e.jqXHR=o.call(l,r,callback,e);else if(o.url===""){var f={};DataTable.util.set(o.dataSrc)(f,[]);callback(f)}else e.jqXHR=t.ajax(u);i&&(o.data=i)}
/**
 * Update the table using an Ajax call
 *  @param {object} settings dataTables settings object
 *  @returns {boolean} Block the table drawing or not
 *  @memberof DataTable#oApi
 */function _fnAjaxUpdate(e){e.iDraw++;_fnProcessingDisplay(e,true);_fnBuildAjax(e,_fnAjaxParameters(e),(function(t){_fnAjaxUpdateDraw(e,t)}))}
/**
 * Build up the parameters in an object needed for a server-side processing
 * request.
 *  @param {object} oSettings dataTables settings object
 *  @returns {bool} block the table drawing or not
 *  @memberof DataTable#oApi
 */function _fnAjaxParameters(e){var t=e.aoColumns,r=e.oFeatures,n=e.oPreviousSearch,i=e.aoPreSearchCols,colData=function(e,r){return typeof t[e][r]==="function"?"function":t[e][r]};return{draw:e.iDraw,columns:t.map((function(e,t){return{data:colData(t,"mData"),name:e.sName,searchable:e.bSearchable,orderable:e.bSortable,search:{value:i[t].search,regex:i[t].regex,fixed:Object.keys(e.searchFixed).map((function(t){return{name:t,term:e.searchFixed[t].toString()}}))}}})),order:_fnSortFlatten(e).map((function(e){return{column:e.col,dir:e.dir,name:colData(e.col,"sName")}})),start:e._iDisplayStart,length:r.bPaginate?e._iDisplayLength:-1,search:{value:n.search,regex:n.regex,fixed:Object.keys(e.searchFixed).map((function(t){return{name:t,term:e.searchFixed[t].toString()}}))}}}
/**
 * Data the data from the server (nuking the old) and redraw the table
 *  @param {object} oSettings dataTables settings object
 *  @param {object} json json data return from the server.
 *  @param {string} json.sEcho Tracking flag for DataTables to match requests
 *  @param {int} json.iTotalRecords Number of records in the data set, not accounting for filtering
 *  @param {int} json.iTotalDisplayRecords Number of records in the data set, accounting for filtering
 *  @param {array} json.aaData The data to display on this page
 *  @param {string} [json.sColumns] Column ordering (sName, comma separated)
 *  @memberof DataTable#oApi
 */function _fnAjaxUpdateDraw(e,t){var r=_fnAjaxDataSrc(e,t);var n=_fnAjaxDataSrcParam(e,"draw",t);var i=_fnAjaxDataSrcParam(e,"recordsTotal",t);var o=_fnAjaxDataSrcParam(e,"recordsFiltered",t);if(n!==void 0){if(n*1<e.iDraw)return;e.iDraw=n*1}r||(r=[]);_fnClearTable(e);e._iRecordsTotal=parseInt(i,10);e._iRecordsDisplay=parseInt(o,10);for(var l=0,s=r.length;l<s;l++)_fnAddData(e,r[l]);e.aiDisplay=e.aiDisplayMaster.slice();_fnColumnTypes(e);_fnDraw(e,true);_fnInitComplete(e);_fnProcessingDisplay(e,false)}
/**
 * Get the data from the JSON data source to use for drawing a table. Using
 * `_fnGetObjectDataFn` allows the data to be sourced from a property of the
 * source object, or from a processing function.
 *  @param {object} settings dataTables settings object
 *  @param  {object} json Data source object / array from the server
 *  @return {array} Array of data to use
 */function _fnAjaxDataSrc(e,r,n){var i="data";if(t.isPlainObject(e.ajax)&&e.ajax.dataSrc!==void 0){var o=e.ajax.dataSrc;typeof o==="string"||typeof o==="function"?i=o:o.data!==void 0&&(i=o.data)}if(!n)return i==="data"?r.aaData||r[i]:i!==""?g(i)(r):r;m(i)(r,n)}
/**
 * Very similar to _fnAjaxDataSrc, but for the other SSP properties
 * @param {*} settings DataTables settings object
 * @param {*} param Target parameter
 * @param {*} json JSON data
 * @returns Resolved value
 */function _fnAjaxDataSrcParam(e,r,n){var i=t.isPlainObject(e.ajax)?e.ajax.dataSrc:null;if(i&&i[r])return g(i[r])(n);var o="";r==="draw"?o="sEcho":r==="recordsTotal"?o="iTotalRecords":r==="recordsFiltered"&&(o="iTotalDisplayRecords");return n[o]!==void 0?n[o]:n[r]}
/**
 * Filter the table using both the global filter and column based filtering
 *  @param {object} settings dataTables settings object
 *  @param {object} input search information
 *  @memberof DataTable#oApi
 */function _fnFilterComplete(e,r){var n=e.aoPreSearchCols;if(_fnDataSource(e)!="ssp"){_fnFilterData(e);e.aiDisplay=e.aiDisplayMaster.slice();_fnFilter(e.aiDisplay,e,r.search,r);t.each(e.searchFixed,(function(t,r){_fnFilter(e.aiDisplay,e,r,{})}));for(var i=0;i<n.length;i++){var o=n[i];_fnFilter(e.aiDisplay,e,o.search,o,i);t.each(e.aoColumns[i].searchFixed,(function(t,r){_fnFilter(e.aiDisplay,e,r,{},i)}))}_fnFilterCustom(e)}e.bFiltered=true;_fnCallbackFire(e,null,"search",[e])}
/**
 * Apply custom filtering functions
 * 
 * This is legacy now that we have named functions, but it is widely used
 * from 1.x, so it is not yet deprecated.
 *  @param {object} oSettings dataTables settings object
 *  @memberof DataTable#oApi
 */function _fnFilterCustom(e){var t=DataTable.ext.search;var r=e.aiDisplay;var n,i;for(var o=0,l=t.length;o<l;o++){var s=[];for(var u=0,f=r.length;u<f;u++){i=r[u];n=e.aoData[i];t[o](e,n._aFilterData,i,n._aData,u)&&s.push(i)}r.length=0;_fnArrayApply(r,s)}}function _fnFilter(e,t,r,n,i){if(r!==""){var o=0;var l=[];var s=typeof r==="function"?r:null;var u=r instanceof RegExp?r:s?null:_fnFilterCreateSearch(r,n);for(o=0;o<e.length;o++){var f=t.aoData[e[o]];var c=i===void 0?f._sFilterRow:f._aFilterData[i];(s&&s(c,f._aData,e[o],i)||u&&u.test(c))&&l.push(e[o])}e.length=l.length;for(o=0;o<l.length;o++)e[o]=l[o]}}
/**
 * Build a regular expression object suitable for searching a table
 *  @param {string} sSearch string to search for
 *  @param {bool} bRegex treat as a regular expression or not
 *  @param {bool} bSmart perform smart filtering or not
 *  @param {bool} bCaseInsensitive Do case insensitive matching or not
 *  @returns {RegExp} constructed object
 *  @memberof DataTable#oApi
 */function _fnFilterCreateSearch(e,r){var n=[];var i=t.extend({},{boundary:false,caseInsensitive:true,exact:false,regex:false,smart:true},r);typeof e!=="string"&&(e=e.toString());e=_normalize(e);if(i.exact)return new RegExp("^"+_(e)+"$",i.caseInsensitive?"i":"");e=i.regex?e:_(e);if(i.smart){var o=e.match(/!?["\u201C][^"\u201D]+["\u201D]|[^ ]+/g)||[""];var l=o.map((function(e){var t=false;var r;if(e.charAt(0)==="!"){t=true;e=e.substring(1)}if(e.charAt(0)==='"'){r=e.match(/^"(.*)"$/);e=r?r[1]:e}else if(e.charAt(0)==="“"){r=e.match(/^\u201C(.*)\u201D$/);e=r?r[1]:e}if(t){e.length>1&&n.push("(?!"+e+")");e=""}return e.replace(/"/g,"")}));var s=n.length?n.join(""):"";var u=i.boundary?"\\b":"";e="^(?=.*?"+u+l.join(")(?=.*?"+u)+")("+s+".)*$"}return new RegExp(e,i.caseInsensitive?"i":"")}
/**
 * Escape a string such that it can be used in a regular expression
 *  @param {string} sVal string to escape
 *  @returns {string} escaped string
 *  @memberof DataTable#oApi
 */var _=DataTable.util.escapeRegex;var b=t("<div>")[0];var y=b.textContent!==void 0;function _fnFilterData(e){var t=e.aoColumns;var r=e.aoData;var n;var i,o,l,s,u;var f=false;for(var c=0;c<r.length;c++)if(r[c]){u=r[c];if(!u._aFilterData){l=[];for(i=0,o=t.length;i<o;i++){n=t[i];if(n.bSearchable){s=_fnGetCellData(e,c,i,"filter");s===null&&(s="");typeof s!=="string"&&s.toString&&(s=s.toString())}else s="";if(s.indexOf&&s.indexOf("&")!==-1){b.innerHTML=s;s=y?b.textContent:b.innerText}s.replace&&(s=s.replace(/[\r\n\u2028]/g,""));l.push(s)}u._aFilterData=l;u._sFilterRow=l.join("  ");f=true}}return f}
/**
 * Draw the table for the first time, adding all required features
 *  @param {object} settings dataTables settings object
 *  @memberof DataTable#oApi
 */function _fnInitialise(e){var r;var n=e.oInit;var i=e.deferLoading;var o=_fnDataSource(e);if(e.bInitialised){_fnBuildHead(e,"header");_fnBuildHead(e,"footer");_fnLoadState(e,n,(function(){_fnDrawHead(e,e.aoHeader);_fnDrawHead(e,e.aoFooter);var l=e.iInitDisplayStart;if(n.aaData)for(r=0;r<n.aaData.length;r++)_fnAddData(e,n.aaData[r]);else(i||o=="dom")&&_fnAddTr(e,t(e.nTBody).children("tr"));e.aiDisplay=e.aiDisplayMaster.slice();_fnAddOptionsHtml(e);_fnSortInit(e);_colGroup(e);_fnProcessingDisplay(e,true);_fnCallbackFire(e,null,"preInit",[e],true);_fnReDraw(e);if(o!="ssp"||i)if(o=="ajax")_fnBuildAjax(e,{},(function(t){var n=_fnAjaxDataSrc(e,t);for(r=0;r<n.length;r++)_fnAddData(e,n[r]);e.iInitDisplayStart=l;_fnReDraw(e);_fnProcessingDisplay(e,false);_fnInitComplete(e)}),e);else{_fnInitComplete(e);_fnProcessingDisplay(e,false)}}))}else setTimeout((function(){_fnInitialise(e)}),200)}
/**
 * Draw the table for the first time, adding all required features
 *  @param {object} settings dataTables settings object
 *  @memberof DataTable#oApi
 */function _fnInitComplete(e){if(!e._bInitComplete){var t=[e,e.json];e._bInitComplete=true;_fnAdjustColumnSizing(e);_fnCallbackFire(e,null,"plugin-init",t,true);_fnCallbackFire(e,"aoInitComplete","init",t,true)}}function _fnLengthChange(e,t){var r=parseInt(t,10);e._iDisplayLength=r;_fnLengthOverflow(e);_fnCallbackFire(e,null,"length",[e,r])}
/**
 * Alter the display settings to change the page
 *  @param {object} settings DataTables settings object
 *  @param {string|int} action Paging action to take: "first", "previous",
 *    "next" or "last" or page number to jump to (integer)
 *  @param [bool] redraw Automatically draw the update or not
 *  @returns {bool} true page has changed, false - no change
 *  @memberof DataTable#oApi
 */function _fnPageChange(e,t,r){var n=e._iDisplayStart,i=e._iDisplayLength,o=e.fnRecordsDisplay();if(o===0||i===-1)n=0;else if(typeof t==="number"){n=t*i;n>o&&(n=0)}else if(t=="first")n=0;else if(t=="previous"){n=i>=0?n-i:0;n<0&&(n=0)}else if(t=="next")n+i<o&&(n+=i);else if(t=="last")n=Math.floor((o-1)/i)*i;else{if(t==="ellipsis")return;_fnLog(e,0,"Unknown paging action: "+t,5)}var l=e._iDisplayStart!==n;e._iDisplayStart=n;_fnCallbackFire(e,null,l?"page":"page-nc",[e]);l&&r&&_fnDraw(e);return l}
/**
 * Generate the node required for the processing node
 *  @param {object} settings DataTables settings object
 */function _processingHtml(e){var r=e.nTable;var n=e.oScroll.sX!==""||e.oScroll.sY!=="";if(e.oFeatures.bProcessing){var i=t("<div/>",{id:e.sTableId+"_processing",class:e.oClasses.processing.container,role:"status"}).html(e.oLanguage.sProcessing).append("<div><div></div><div></div><div></div><div></div></div>");n?i.prependTo(t("div.dt-scroll",e.nTableWrapper)):i.insertBefore(r);t(r).on("processing.dt.DT",(function(e,t,r){i.css("display",r?"block":"none")}))}}
/**
 * Display or hide the processing indicator
 *  @param {object} settings DataTables settings object
 *  @param {bool} show Show the processing indicator (true) or not (false)
 */function _fnProcessingDisplay(e,t){e.bDrawing&&t===false||_fnCallbackFire(e,null,"processing",[e,t])}
/**
 * Show the processing element if an action takes longer than a given time
 *
 * @param {*} settings DataTables settings object
 * @param {*} enable Do (true) or not (false) async processing (local feature enablement)
 * @param {*} run Function to run
 */function _fnProcessingRun(e,t,r){if(t){_fnProcessingDisplay(e,true);setTimeout((function(){r();_fnProcessingDisplay(e,false)}),0)}else r()}
/**
 * Add any control elements for the table - specifically scrolling
 *  @param {object} settings dataTables settings object
 *  @returns {node} Node to add to the DOM
 *  @memberof DataTable#oApi
 */function _fnFeatureHtmlTable(e){var r=t(e.nTable);var n=e.oScroll;if(n.sX===""&&n.sY==="")return e.nTable;var i=n.sX;var o=n.sY;var l=e.oClasses.scrolling;var s=e.captionNode;var u=s?s._captionSide:null;var f=t(r[0].cloneNode(false));var c=t(r[0].cloneNode(false));var d=r.children("tfoot");var p="<div/>";var size=function(e){return e?_fnStringToCss(e):null};d.length||(d=null);var v=t(p,{class:l.container}).append(t(p,{class:l.header.self}).css({overflow:"hidden",position:"relative",border:0,width:i?size(i):"100%"}).append(t(p,{class:l.header.inner}).css({"box-sizing":"content-box",width:n.sXInner||"100%"}).append(f.removeAttr("id").css("margin-left",0).append(u==="top"?s:null).append(r.children("thead"))))).append(t(p,{class:l.body}).css({position:"relative",overflow:"auto",width:size(i)}).append(r));d&&v.append(t(p,{class:l.footer.self}).css({overflow:"hidden",border:0,width:i?size(i):"100%"}).append(t(p,{class:l.footer.inner}).append(c.removeAttr("id").css("margin-left",0).append(u==="bottom"?s:null).append(r.children("tfoot")))));var h=v.children();var g=h[0];var m=h[1];var _=d?h[2]:null;t(m).on("scroll.DT",(function(){var e=this.scrollLeft;g.scrollLeft=e;d&&(_.scrollLeft=e)}));t("th, td",g).on("focus",(function(){var e=g.scrollLeft;m.scrollLeft=e;d&&(m.scrollLeft=e)}));t(m).css("max-height",o);n.bCollapse||t(m).css("height",o);e.nScrollHead=g;e.nScrollBody=m;e.nScrollFoot=_;e.aoDrawCallback.push(_fnScrollDraw);return v[0]}
/**
 * Update the header, footer and body tables for resizing - i.e. column
 * alignment.
 *
 * Welcome to the most horrible function DataTables. The process that this
 * function follows is basically:
 *   1. Re-create the table inside the scrolling div
 *   2. Correct colgroup > col values if needed
 *   3. Copy colgroup > col over to header and footer
 *   4. Clean up
 *
 *  @param {object} settings dataTables settings object
 *  @memberof DataTable#oApi
 */function _fnScrollDraw(e){var r,n,i=e.oScroll,o=i.iBarWidth,l=t(e.nScrollHead),s=l.children("div"),u=s.children("table"),f=e.nScrollBody,c=t(f),d=t(e.nScrollFoot),p=d.children("div"),v=p.children("table"),h=t(e.nTHead),g=t(e.nTable),m=e.nTFoot&&t("th, td",e.nTFoot).length?t(e.nTFoot):null,_=e.oBrowser;var b=f.scrollHeight>f.clientHeight;if(e.scrollBarVis===b||e.scrollBarVis===void 0){e.scrollBarVis=b;g.children("thead, tfoot").remove();r=h.clone().prependTo(g);r.find("th, td").removeAttr("tabindex");r.find("[id]").removeAttr("id");if(m){n=m.clone().prependTo(g);n.find("[id]").removeAttr("id")}if(e.aiDisplay.length){var y=null;var D=_fnDataSource(e)!=="ssp"?e._iDisplayStart:0;for(x=D;x<D+e.aiDisplay.length;x++){var C=e.aiDisplay[x];var S=e.aoData[C].nTr;if(S){y=S;break}}if(y){var w=t(y).children("th, td").map((function(r){return{idx:_fnVisibleToColumnIndex(e,r),width:t(this).outerWidth()}}));for(var x=0;x<w.length;x++){var T=e.aoColumns[w[x].idx].colEl[0];var A=T.style.width.replace("px","");if(A!==w[x].width){T.style.width=w[x].width+"px";i.sX&&(T.style.minWidth=w[x].width+"px")}}}}u.find("colgroup").remove();u.append(e.colgroup.clone());if(m){v.find("colgroup").remove();v.append(e.colgroup.clone())}t("th, td",r).each((function(){t(this.childNodes).wrapAll('<div class="dt-scroll-sizing">')}));m&&t("th, td",n).each((function(){t(this.childNodes).wrapAll('<div class="dt-scroll-sizing">')}));var F=Math.floor(g.height())>f.clientHeight||c.css("overflow-y")=="scroll";var I="padding"+(_.bScrollbarLeft?"Left":"Right");var L=g.outerWidth();u.css("width",_fnStringToCss(L));s.css("width",_fnStringToCss(L)).css(I,F?o+"px":"0px");if(m){v.css("width",_fnStringToCss(L));p.css("width",_fnStringToCss(L)).css(I,F?o+"px":"0px")}g.children("colgroup").prependTo(g);c.trigger("scroll");!e.bSorted&&!e.bFiltered||e._drawHold||(f.scrollTop=0)}else{e.scrollBarVis=b;_fnAdjustColumnSizing(e)}}
/**
 * Calculate the width of columns for the table
 *  @param {object} settings dataTables settings object
 *  @memberof DataTable#oApi
 */function _fnCalculateColumnWidths(e){if(e.oFeatures.bAutoWidth){var n,i,o,l=e.nTable,s=e.aoColumns,u=e.oScroll,f=u.sY,c=u.sX,d=u.sXInner,p=_fnGetColumns(e,"bVisible"),v=l.getAttribute("width"),h=l.parentNode;var g=l.style.width;var m=_fnWrapperWidth(e);if(m===e.containerWidth)return false;e.containerWidth=m;if(!g&&!v){l.style.width="100%";g="100%"}g&&g.indexOf("%")!==-1&&(v=g);_fnCallbackFire(e,null,"column-calc",{visible:p},false);var _=t(l.cloneNode()).css("visibility","hidden").removeAttr("id");_.append("<tbody>");var b=t("<tr/>").appendTo(_.find("tbody"));_.append(t(e.nTHead).clone()).append(t(e.nTFoot).clone());_.find("tfoot th, tfoot td").css("width","");_.find("thead th, thead td").each((function(){var r=_fnColumnsSumWidth(e,this,true,false);if(r){this.style.width=r;if(c){this.style.minWidth=r;t(this).append(t("<div/>").css({width:r,margin:0,padding:0,border:0,height:1}))}}else this.style.width=""}));for(n=0;n<p.length;n++){o=p[n];i=s[o];var y=_fnGetMaxLenString(e,o);var D=r.type.className[i.sType];var C=y+i.sContentPadding;var S=y.indexOf("<")===-1?document.createTextNode(C):C;t("<td/>").addClass(D).addClass(i.sClass).append(S).appendTo(b)}t("[name]",_).removeAttr("name");var w=t("<div/>").css(c||f?{position:"absolute",top:0,left:0,height:1,right:0,overflow:"hidden"}:{}).append(_).appendTo(h);if(c&&d)_.width(d);else if(c){_.css("width","auto");_.removeAttr("width");_.outerWidth()<h.clientWidth&&v&&_.outerWidth(h.clientWidth)}else f?_.outerWidth(h.clientWidth):v&&_.outerWidth(v);var x=0;var T=_.find("tbody tr").eq(0).children();for(n=0;n<p.length;n++){var A=T[n].getBoundingClientRect().width;x+=A;s[p[n]].sWidth=_fnStringToCss(A)}l.style.width=_fnStringToCss(x);w.remove();v&&(l.style.width=_fnStringToCss(v));if((v||c)&&!e._reszEvt){var F=DataTable.util.throttle((function(){var t=_fnWrapperWidth(e);e.bDestroying||t===0||_fnAdjustColumnSizing(e)}));if(window.ResizeObserver){var I=t(e.nTableWrapper).is(":visible");var L=t("<div>").css({width:"100%",height:0}).addClass("dt-autosize").appendTo(e.nTableWrapper);e.resizeObserver=new ResizeObserver((function(e){I?I=false:F()}));e.resizeObserver.observe(L[0])}else t(window).on("resize.DT-"+e.sInstance,F);e._reszEvt=true}}}
/**
 * Get the width of the DataTables wrapper element
 *
 * @param {*} settings DataTables settings object
 * @returns Width
 */function _fnWrapperWidth(e){return t(e.nTableWrapper).is(":visible")?t(e.nTableWrapper).width():0}
/**
 * Get the maximum strlen for each data column
 *  @param {object} settings dataTables settings object
 *  @param {int} colIdx column of interest
 *  @returns {string} string of the max length
 *  @memberof DataTable#oApi
 */function _fnGetMaxLenString(e,t){var r=e.aoColumns[t];if(!r.maxLenString){var n,i="",o=-1;for(var l=0,s=e.aiDisplayMaster.length;l<s;l++){var u=e.aiDisplayMaster[l];var f=_fnGetRowDisplay(e,u)[t];var c=f&&typeof f==="object"&&f.nodeType?f.innerHTML:f+"";c=c.replace(/id=".*?"/g,"").replace(/name=".*?"/g,"");n=_stripHtml(c).replace(/&nbsp;/g," ");if(n.length>o){i=c;o=n.length}}r.maxLenString=i}return r.maxLenString}
/**
 * Append a CSS unit (only if required) to a string
 *  @param {string} value to css-ify
 *  @returns {string} value with css unit
 *  @memberof DataTable#oApi
 */function _fnStringToCss(e){return e===null?"0px":typeof e=="number"?e<0?"0px":e+"px":e.match(/\d$/)?e+"px":e}
/**
 * Re-insert the `col` elements for current visibility
 *
 * @param {*} settings DT settings
 */function _colGroup(e){var t=e.aoColumns;e.colgroup.empty();for(M=0;M<t.length;M++)t[M].bVisible&&e.colgroup.append(t[M].colEl)}function _fnSortInit(e){var t=e.nTHead;var r=t.querySelectorAll("tr");var n=e.bSortCellsTop;var i=':not([data-dt-order="disable"]):not([data-dt-order="icon-only"])';n===true?t=r[0]:n===false&&(t=r[r.length-1]);_fnSortAttachListener(e,t,t===e.nTHead?"tr"+i+" th"+i+", tr"+i+" td"+i:"th"+i+", td"+i);var o=[];_fnSortResolve(e,o,e.aaSorting);e.aaSorting=o}function _fnSortAttachListener(e,t,r,n,i){_fnBindAction(t,r,(function(t){var r=false;var o=n===void 0?_fnColumnsFromHeader(t.target):[n];if(o.length){for(var l=0,s=o.length;l<s;l++){var u=_fnSortAdd(e,o[l],l,t.shiftKey);u!==false&&(r=true);if(e.aaSorting.length===1&&e.aaSorting[0][1]==="")break}r&&_fnProcessingRun(e,true,(function(){_fnSort(e);_fnSortDisplay(e,e.aiDisplay);_fnReDraw(e,false,false);i&&i()}))}}))}
/**
 * Sort the display array to match the master's order
 * @param {*} settings
 */function _fnSortDisplay(e,t){if(!(t.length<2)){var r=e.aiDisplayMaster;var n={};var i={};var o;for(o=0;o<r.length;o++)n[r[o]]=o;for(o=0;o<t.length;o++)i[t[o]]=n[t[o]];t.sort((function(e,t){return i[e]-i[t]}))}}function _fnSortResolve(e,r,n){var push=function(n){if(t.isPlainObject(n)){if(n.idx!==void 0)r.push([n.idx,n.dir]);else if(n.name){var i=_pluck(e.aoColumns,"sName");var o=i.indexOf(n.name);o!==-1&&r.push([o,n.dir])}}else r.push(n)};if(t.isPlainObject(n))push(n);else if(n.length&&typeof n[0]==="number")push(n);else if(n.length)for(var i=0;i<n.length;i++)push(n[i])}function _fnSortFlatten(e){var r,n,i,o,l,s,u,f=[],c=DataTable.ext.type.order,d=e.aoColumns,p=e.aaSortingFixed,v=t.isPlainObject(p),h=[];if(!e.oFeatures.bSort)return f;Array.isArray(p)&&_fnSortResolve(e,h,p);v&&p.pre&&_fnSortResolve(e,h,p.pre);_fnSortResolve(e,h,e.aaSorting);v&&p.post&&_fnSortResolve(e,h,p.post);for(r=0;r<h.length;r++){u=h[r][0];if(d[u]){o=d[u].aDataSort;for(n=0,i=o.length;n<i;n++){l=o[n];s=d[l].sType||"string";h[r]._idx===void 0&&(h[r]._idx=d[l].asSorting.indexOf(h[r][1]));h[r][1]&&f.push({src:u,col:l,dir:h[r][1],index:h[r]._idx,type:s,formatter:c[s+"-pre"],sorter:c[s+"-"+h[r][1]]})}}}return f}
/**
 * Change the order of the table
 *  @param {object} oSettings dataTables settings object
 *  @memberof DataTable#oApi
 */function _fnSort(e,t,r){var n,i,o,l,s,u=[],f=DataTable.ext.type.order,c=e.aoData,d=e.aiDisplayMaster;_fnColumnTypes(e);if(t!==void 0){var p=e.aoColumns[t];s=[{src:t,col:t,dir:r,index:0,type:p.sType,formatter:f[p.sType+"-pre"],sorter:f[p.sType+"-"+r]}];d=d.slice()}else s=_fnSortFlatten(e);for(n=0,i=s.length;n<i;n++){l=s[n];_fnSortData(e,l.col)}if(_fnDataSource(e)!="ssp"&&s.length!==0){for(n=0,o=d.length;n<o;n++)u[n]=n;s.length&&s[0].dir==="desc"&&e.orderDescReverse&&u.reverse();d.sort((function(e,t){var r,n,i,o,l,f=s.length,d=c[e]._aSortData,p=c[t]._aSortData;for(i=0;i<f;i++){l=s[i];r=d[l.col];n=p[l.col];if(l.sorter){o=l.sorter(r,n);if(o!==0)return o}else{o=r<n?-1:r>n?1:0;if(o!==0)return l.dir==="asc"?o:-o}}r=u[e];n=u[t];return r<n?-1:r>n?1:0}))}else s.length===0&&d.sort((function(e,t){return e<t?-1:e>t?1:0}));if(t===void 0){e.bSorted=true;e.sortDetails=s;_fnCallbackFire(e,null,"order",[e,s])}return d}
/**
 * Function to run on user sort request
 *  @param {object} settings dataTables settings object
 *  @param {node} attachTo node to attach the handler to
 *  @param {int} colIdx column sorting index
 *  @param {int} addIndex Counter
 *  @param {boolean} [shift=false] Shift click add
 *  @param {function} [callback] callback function
 *  @memberof DataTable#oApi
 */function _fnSortAdd(e,t,r,n){var i=e.aoColumns[t];var o=e.aaSorting;var l=i.asSorting;var s;var next=function(e,t){var r=e._idx;r===void 0&&(r=l.indexOf(e[1]));return r+1<l.length?r+1:t?null:0};if(!i.bSortable)return false;typeof o[0]==="number"&&(o=e.aaSorting=[o]);if((n||r)&&e.oFeatures.bSortMulti){var u=_pluck(o,"0").indexOf(t);if(u!==-1){s=next(o[u],true);s===null&&o.length===1&&(s=0);if(s===null)o.splice(u,1);else{o[u][1]=l[s];o[u]._idx=s}}else if(n){o.push([t,l[0],0]);o[o.length-1]._idx=0}else{o.push([t,o[0][1],0]);o[o.length-1]._idx=0}}else if(o.length&&o[0][0]==t){s=next(o[0]);o.length=1;o[0][1]=l[s];o[0]._idx=s}else{o.length=0;o.push([t,l[0]]);o[0]._idx=0}}
/**
 * Set the sorting classes on table's body, Note: it is safe to call this function
 * when bSort and bSortClasses are false
 *  @param {object} oSettings dataTables settings object
 *  @memberof DataTable#oApi
 */function _fnSortingClasses(e){var r=e.aLastSort;var n=e.oClasses.order.position;var i=_fnSortFlatten(e);var o=e.oFeatures;var l,s,u;if(o.bSort&&o.bSortClasses){for(l=0,s=r.length;l<s;l++){u=r[l].src;t(_pluck(e.aoData,"anCells",u)).removeClass(n+(l<2?l+1:3))}for(l=0,s=i.length;l<s;l++){u=i[l].src;t(_pluck(e.aoData,"anCells",u)).addClass(n+(l<2?l+1:3))}}e.aLastSort=i}function _fnSortData(e,t){var r=e.aoColumns[t];var n=DataTable.ext.order[r.sSortDataType];var i;n&&(i=n.call(e.oInstance,e,t,_fnColumnIndexToVisible(e,t)));var o,l;var s=DataTable.ext.type.order[r.sType+"-pre"];var u=e.aoData;for(var f=0;f<u.length;f++)if(u[f]){o=u[f];o._aSortData||(o._aSortData=[]);if(!o._aSortData[t]||n){l=n?i[f]:_fnGetCellData(e,f,t,"sort");o._aSortData[t]=s?s(l,e):l}}}
/**
 * State information for a table
 *
 * @param {*} settings
 * @returns State object
 */function _fnSaveState(e){if(!e._bLoadingState){var r=[];_fnSortResolve(e,r,e.aaSorting);var n=e.aoColumns;var i={time:+new Date,start:e._iDisplayStart,length:e._iDisplayLength,order:r.map((function(e){return n[e[0]]&&n[e[0]].sName?[n[e[0]].sName,e[1]]:e.slice()})),search:t.extend({},e.oPreviousSearch),columns:e.aoColumns.map((function(r,n){return{name:r.sName,visible:r.bVisible,search:t.extend({},e.aoPreSearchCols[n])}}))};e.oSavedState=i;_fnCallbackFire(e,"aoStateSaveParams","stateSaveParams",[e,i]);e.oFeatures.bStateSave&&!e.bDestroying&&e.fnStateSaveCallback.call(e.oInstance,e,i)}}
/**
 * Attempt to load a saved table state
 *  @param {object} oSettings dataTables settings object
 *  @param {object} oInit DataTables init object so we can override settings
 *  @param {function} callback Callback to execute when the state has been loaded
 *  @memberof DataTable#oApi
 */function _fnLoadState(e,t,r){if(e.oFeatures.bStateSave){var loaded=function(t){_fnImplementState(e,t,r)};var n=e.fnStateLoadCallback.call(e.oInstance,e,loaded);n!==void 0&&_fnImplementState(e,n,r);return true}r()}function _fnImplementState(e,r,n){var i,o;var l=e.aoColumns;var s=_pluck(e.aoColumns,"sName");e._bLoadingState=true;var u=e._bInitComplete?new DataTable.Api(e):null;if(r&&r.time){var f=e.iStateDuration;if(f>0&&r.time<+new Date-f*1e3){e._bLoadingState=false;n()}else{var c=_fnCallbackFire(e,"aoStateLoadParams","stateLoadParams",[e,r]);if(c.indexOf(false)===-1){e.oLoadedState=t.extend(true,{},r);_fnCallbackFire(e,null,"stateLoadInit",[e,r],true);r.length!==void 0&&(u?u.page.len(r.length):e._iDisplayLength=r.length);if(r.start!==void 0)if(u===null){e._iDisplayStart=r.start;e.iInitDisplayStart=r.start}else _fnPageChange(e,r.start/e._iDisplayLength);if(r.order!==void 0){e.aaSorting=[];t.each(r.order,(function(t,r){var n=[r[0],r[1]];if(typeof r[0]==="string"){var i=s.indexOf(r[0]);n[0]=i>=0?i:0}else n[0]>=l.length&&(n[0]=0);e.aaSorting.push(n)}))}r.search!==void 0&&t.extend(e.oPreviousSearch,r.search);if(r.columns){var d=r.columns;var p=_pluck(r.columns,"name");if(p.join("").length&&p.join("")!==s.join("")){d=[];for(i=0;i<s.length;i++)if(s[i]!=""){var v=p.indexOf(s[i]);v>=0?d.push(r.columns[v]):d.push({})}else d.push({})}if(d.length===l.length){for(i=0,o=d.length;i<o;i++){var h=d[i];h.visible!==void 0&&(u?u.column(i).visible(h.visible,false):l[i].bVisible=h.visible);h.search!==void 0&&t.extend(e.aoPreSearchCols[i],h.search)}u&&u.columns.adjust()}}e._bLoadingState=false;_fnCallbackFire(e,"aoStateLoaded","stateLoaded",[e,r]);n()}else{e._bLoadingState=false;n()}}}else{e._bLoadingState=false;n()}}
/**
 * Log an error message
 *  @param {object} settings dataTables settings object
 *  @param {int} level log error messages, or display them to the user
 *  @param {string} msg error message
 *  @param {int} tn Technical note id to get more information about the error.
 *  @memberof DataTable#oApi
 */function _fnLog(e,t,r,n){r="DataTables warning: "+(e?"table id="+e.sTableId+" - ":"")+r;n&&(r+=". For more information about this error, please see https://datatables.net/tn/"+n);if(t)window.console&&console.log&&console.log(r);else{var i=DataTable.ext;var o=i.sErrMode||i.errMode;e&&_fnCallbackFire(e,null,"dt-error",[e,n,r],true);if(o=="alert")alert(r);else{if(o=="throw")throw new Error(r);typeof o=="function"&&o(e,n,r)}}}
/**
 * See if a property is defined on one object, if so assign it to the other object
 *  @param {object} ret target object
 *  @param {object} src source object
 *  @param {string} name property
 *  @param {string} [mappedName] name to map too - optional, name used if not given
 *  @memberof DataTable#oApi
 */function _fnMap(e,r,n,i){if(Array.isArray(n))t.each(n,(function(t,n){Array.isArray(n)?_fnMap(e,r,n[0],n[1]):_fnMap(e,r,n)}));else{i===void 0&&(i=n);r[n]!==void 0&&(e[i]=r[n])}}
/**
 * Extend objects - very similar to jQuery.extend, but deep copy objects, and
 * shallow copy arrays. The reason we need to do this, is that we don't want to
 * deep copy array init values (such as aaSorting) since the dev wouldn't be
 * able to override them, but we do want to deep copy arrays.
 *  @param {object} out Object to extend
 *  @param {object} extender Object from which the properties will be applied to
 *      out
 *  @param {boolean} breakRefs If true, then arrays will be sliced to take an
 *      independent copy with the exception of the `data` or `aaData` parameters
 *      if they are present. This is so you can pass in a collection to
 *      DataTables and have that used as your data source without breaking the
 *      references
 *  @returns {object} out Reference, just for convenience - out === the return.
 *  @memberof DataTable#oApi
 *  @todo This doesn't take account of arrays inside the deep copied objects.
 */function _fnExtend(e,r,n){var i;for(var o in r)if(Object.prototype.hasOwnProperty.call(r,o)){i=r[o];if(t.isPlainObject(i)){t.isPlainObject(e[o])||(e[o]={});t.extend(true,e[o],i)}else n&&o!=="data"&&o!=="aaData"&&Array.isArray(i)?e[o]=i.slice():e[o]=i}return e}
/**
 * Bind an event handers to allow a click or return key to activate the callback.
 * This is good for accessibility since a return on the keyboard will have the
 * same effect as a click, if the element has focus.
 *  @param {element} n Element to bind the action to
 *  @param {object|string} selector Selector (for delegated events) or data object
 *   to pass to the triggered function
 *  @param {function} fn Callback function for when the event is triggered
 *  @memberof DataTable#oApi
 */function _fnBindAction(e,r,n){t(e).on("click.DT",r,(function(e){n(e)})).on("keypress.DT",r,(function(e){if(e.which===13){e.preventDefault();n(e)}})).on("selectstart.DT",r,(function(){return false}))}
/**
 * Register a callback function. Easily allows a callback function to be added to
 * an array store of callback functions that can then all be called together.
 *  @param {object} settings dataTables settings object
 *  @param {string} store Name of the array storage for the callbacks in oSettings
 *  @param {function} fn Function to be called back
 *  @memberof DataTable#oApi
 */function _fnCallbackReg(e,t,r){r&&e[t].push(r)}
/**
 * Fire callback functions and trigger events. Note that the loop over the
 * callback array store is done backwards! Further note that you do not want to
 * fire off triggers in time sensitive applications (for example cell creation)
 * as its slow.
 *  @param {object} settings dataTables settings object
 *  @param {string} callbackArr Name of the array storage for the callbacks in
 *      oSettings
 *  @param {string} eventName Name of the jQuery custom event to trigger. If
 *      null no trigger is fired
 *  @param {array} args Array of arguments to pass to the callback function /
 *      trigger
 *  @param {boolean} [bubbles] True if the event should bubble
 *  @memberof DataTable#oApi
 */function _fnCallbackFire(e,r,n,i,o){var l=[];r&&(l=e[r].slice().reverse().map((function(t){return t.apply(e.oInstance,i)})));if(n!==null){var s=t.Event(n+".dt");var u=t(e.nTable);s.dt=e.api;u[o?"trigger":"triggerHandler"](s,i);o&&u.parents("body").length===0&&t("body").trigger(s,i);l.push(s.result)}return l}function _fnLengthOverflow(e){var t=e._iDisplayStart,r=e.fnDisplayEnd(),n=e._iDisplayLength;t>=r&&(t=r-n);t-=t%n;(n===-1||t<0)&&(t=0);e._iDisplayStart=t}function _fnRenderer(e,r){var n=e.renderer;var i=DataTable.ext.renderer[r];return t.isPlainObject(n)&&n[r]?i[n[r]]||i._:typeof n==="string"&&i[n]||i._}
/**
 * Detect the data source being used for the table. Used to simplify the code
 * a little (ajax) and to make it compress a little smaller.
 *
 *  @param {object} settings dataTables settings object
 *  @returns {string} Data source
 *  @memberof DataTable#oApi
 */function _fnDataSource(e){return e.oFeatures.bServerSide?"ssp":e.ajax?"ajax":"dom"}
/**
 * Common replacement for language strings
 *
 * @param {*} settings DT settings object
 * @param {*} str String with values to replace
 * @param {*} entries Plural number for _ENTRIES_ - can be undefined
 * @returns String
 */function _fnMacros(e,t,r){var n=e.fnFormatNumber,i=e._iDisplayStart+1,o=e._iDisplayLength,l=e.fnRecordsDisplay(),s=e.fnRecordsTotal(),u=o===-1;return t.replace(/_START_/g,n.call(e,i)).replace(/_END_/g,n.call(e,e.fnDisplayEnd())).replace(/_MAX_/g,n.call(e,s)).replace(/_TOTAL_/g,n.call(e,l)).replace(/_PAGE_/g,n.call(e,u?1:Math.ceil(i/o))).replace(/_PAGES_/g,n.call(e,u?1:Math.ceil(l/o))).replace(/_ENTRIES_/g,e.api.i18n("entries","",r)).replace(/_ENTRIES-MAX_/g,e.api.i18n("entries","",s)).replace(/_ENTRIES-TOTAL_/g,e.api.i18n("entries","",l))}
/**
 * Add elements to an array as quickly as possible, but stack stafe.
 *
 * @param {*} arr Array to add the data to
 * @param {*} data Data array that is to be added
 * @returns 
 */function _fnArrayApply(e,t){if(t)if(t.length<1e4)e.push.apply(e,t);else for(M=0;M<t.length;M++)e.push(t[M])}
/**
 * Computed structure of the DataTables API, defined by the options passed to
 * `DataTable.Api.register()` when building the API.
 *
 * The structure is built in order to speed creation and extension of the Api
 * objects since the extensions are effectively pre-parsed.
 *
 * The array is an array of objects with the following structure, where this
 * base array represents the Api prototype base:
 *
 *     [
 *       {
 *         name:      'data'                -- string   - Property name
 *         val:       function () {},       -- function - Api method (or undefined if just an object
 *         methodExt: [ ... ],              -- array    - Array of Api object definitions to extend the method result
 *         propExt:   [ ... ]               -- array    - Array of Api object definitions to extend the property
 *       },
 *       {
 *         name:     'row'
 *         val:       {},
 *         methodExt: [ ... ],
 *         propExt:   [
 *           {
 *             name:      'data'
 *             val:       function () {},
 *             methodExt: [ ... ],
 *             propExt:   [ ... ]
 *           },
 *           ...
 *         ]
 *       }
 *     ]
 *
 * @type {Array}
 * @ignore
 */var D=[];
/**
 * `Array.prototype` reference.
 *
 * @type object
 * @ignore
 */var C=Array.prototype;
/**
 * Abstraction for `context` parameter of the `Api` constructor to allow it to
 * take several different forms for ease of use.
 *
 * Each of the input parameter types will be converted to a DataTables settings
 * object where possible.
 *
 * @param  {string|node|jQuery|object} mixed DataTable identifier. Can be one
 *   of:
 *
 *   * `string` - jQuery selector. Any DataTables' matching the given selector
 *     with be found and used.
 *   * `node` - `TABLE` node which has already been formed into a DataTable.
 *   * `jQuery` - A jQuery object of `TABLE` nodes.
 *   * `object` - DataTables settings object
 *   * `DataTables.Api` - API instance
 * @return {array|null} Matching DataTables settings objects. `null` or
 *   `undefined` is returned if no matching DataTable is found.
 * @ignore
 */var _toSettings=function(e){var r,n;var i=DataTable.settings;var o=_pluck(i,"nTable");if(!e)return[];if(e.nTable&&e.oFeatures)return[e];if(e.nodeName&&e.nodeName.toLowerCase()==="table"){r=o.indexOf(e);return r!==-1?[i[r]]:null}if(e&&typeof e.settings==="function")return e.settings().toArray();typeof e==="string"?n=t(e).get():e instanceof t&&(n=e.get());return n?i.filter((function(e,t){return n.includes(o[t])})):void 0};
/**
 * DataTables API class - used to control and interface with  one or more
 * DataTables enhanced tables.
 *
 * The API class is heavily based on jQuery, presenting a chainable interface
 * that you can use to interact with tables. Each instance of the API class has
 * a "context" - i.e. the tables that it will operate on. This could be a single
 * table, all tables on a page or a sub-set thereof.
 *
 * Additionally the API is designed to allow you to easily work with the data in
 * the tables, retrieving and manipulating it as required. This is done by
 * presenting the API class as an array like interface. The contents of the
 * array depend upon the actions requested by each method (for example
 * `rows().nodes()` will return an array of nodes, while `rows().data()` will
 * return an array of objects or arrays depending upon your table's
 * configuration). The API object has a number of array like methods (`push`,
 * `pop`, `reverse` etc) as well as additional helper methods (`each`, `pluck`,
 * `unique` etc) to assist your working with the data held in a table.
 *
 * Most methods (those which return an Api instance) are chainable, which means
 * the return from a method call also has all of the methods available that the
 * top level object had. For example, these two calls are equivalent:
 *
 *     // Not chained
 *     api.row.add( {...} );
 *     api.draw();
 *
 *     // Chained
 *     api.row.add( {...} ).draw();
 *
 * @class DataTable.Api
 * @param {array|object|string|jQuery} context DataTable identifier. This is
 *   used to define which DataTables enhanced tables this API will operate on.
 *   Can be one of:
 *
 *   * `string` - jQuery selector. Any DataTables' matching the given selector
 *     with be found and used.
 *   * `node` - `TABLE` node which has already been formed into a DataTable.
 *   * `jQuery` - A jQuery object of `TABLE` nodes.
 *   * `object` - DataTables settings object
 * @param {array} [data] Data to initialise the Api instance with.
 *
 * @example
 *   // Direct initialisation during DataTables construction
 *   var api = $('#example').DataTable();
 *
 * @example
 *   // Initialisation using a DataTables jQuery object
 *   var api = $('#example').dataTable().api();
 *
 * @example
 *   // Initialisation as a constructor
 *   var api = new DataTable.Api( 'table.dataTable' );
 */n=function(e,t){if(!(this instanceof n))return new n(e,t);var r;var i=[];var ctxSettings=function(e){var t=_toSettings(e);t&&i.push.apply(i,t)};if(Array.isArray(e))for(r=0;r<e.length;r++)ctxSettings(e[r]);else ctxSettings(e);this.context=i.length>1?_unique(i):i;_fnArrayApply(this,t);this.selector={rows:null,cols:null,opts:null};n.extend(this,this,D)};DataTable.Api=n;t.extend(n.prototype,{any:function(){return this.count()!==0},context:[],count:function(){return this.flatten().length},each:function(e){for(var t=0,r=this.length;t<r;t++)e.call(this,this[t],t,this);return this},eq:function(e){var t=this.context;return t.length>e?new n(t[e],this[e]):null},filter:function(e){var t=C.filter.call(this,e,this);return new n(this.context,t)},flatten:function(){var e=[];return new n(this.context,e.concat.apply(e,this.toArray()))},get:function(e){return this[e]},join:C.join,includes:function(e){return this.indexOf(e)!==-1},indexOf:C.indexOf,iterator:function(e,t,r,i){var o,l,s,u,f,c,d,p,v=[],h=this.context,g=this.selector;if(typeof e==="string"){i=r;r=t;t=e;e=false}for(l=0,s=h.length;l<s;l++){var m=new n(h[l]);if(t==="table"){o=r.call(m,h[l],l);o!==void 0&&v.push(o)}else if(t==="columns"||t==="rows"){o=r.call(m,h[l],this[l],l);o!==void 0&&v.push(o)}else if(t==="every"||t==="column"||t==="column-rows"||t==="row"||t==="cell"){d=this[l];t==="column-rows"&&(c=_selector_row_indexes(h[l],g.opts));for(u=0,f=d.length;u<f;u++){p=d[u];o=t==="cell"?r.call(m,h[l],p.row,p.column,l,u):r.call(m,h[l],p,l,u,c);o!==void 0&&v.push(o)}}}if(v.length||i){var _=new n(h,e?v.concat.apply([],v):v);var b=_.selector;b.rows=g.rows;b.cols=g.cols;b.opts=g.opts;return _}return this},lastIndexOf:C.lastIndexOf,length:0,map:function(e){var t=C.map.call(this,e,this);return new n(this.context,t)},pluck:function(e){var t=DataTable.util.get(e);return this.map((function(e){return t(e)}))},pop:C.pop,push:C.push,reduce:C.reduce,reduceRight:C.reduceRight,reverse:C.reverse,selector:null,shift:C.shift,slice:function(){return new n(this.context,this)},sort:C.sort,splice:C.splice,toArray:function(){return C.slice.call(this)},to$:function(){return t(this)},toJQuery:function(){return t(this)},unique:function(){return new n(this.context,_unique(this.toArray()))},unshift:C.unshift});function _api_scope(e,t,r){return function(){var i=t.apply(e||this,arguments);n.extend(i,i,r.methodExt);return i}}function _api_find(e,t){for(var r=0,n=e.length;r<n;r++)if(e[r].name===t)return e[r];return null}window.__apiStruct=D;n.extend=function(e,t,r){if(r.length&&t&&(t instanceof n||t.__dt_wrapper)){var i,o,l;for(i=0,o=r.length;i<o;i++){l=r[i];if(l.name!=="__proto__"){t[l.name]=l.type==="function"?_api_scope(e,l.val,l):l.type==="object"?{}:l.val;t[l.name].__dt_wrapper=true;n.extend(e,t[l.name],l.propExt)}}}};n.register=i=function(e,r){if(Array.isArray(e))for(var i=0,o=e.length;i<o;i++)n.register(e[i],r);else{var l,s,u,f,c=e.split("."),d=D;for(l=0,s=c.length;l<s;l++){f=c[l].indexOf("()")!==-1;u=f?c[l].replace("()",""):c[l];var p=_api_find(d,u);if(!p){p={name:u,val:{},methodExt:[],propExt:[],type:"object"};d.push(p)}if(l===s-1){p.val=r;p.type=typeof r==="function"?"function":t.isPlainObject(r)?"object":"other"}else d=f?p.methodExt:p.propExt}}};n.registerPlural=o=function(e,t,r){n.register(e,r);n.register(t,(function(){var e=r.apply(this,arguments);return e===this?this:e instanceof n?e.length?Array.isArray(e[0])?new n(e.context,e[0]):e[0]:void 0:e}))};
/**
 * Selector for HTML tables. Apply the given selector to the give array of
 * DataTables settings objects.
 *
 * @param {string|integer} [selector] jQuery selector string or integer
 * @param  {array} Array of DataTables settings objects to be filtered
 * @return {array}
 * @ignore
 */var __table_selector=function(e,r){if(Array.isArray(e)){var n=[];e.forEach((function(e){var t=__table_selector(e,r);_fnArrayApply(n,t)}));return n.filter((function(e){return e}))}if(typeof e==="number")return[r[e]];var i=r.map((function(e){return e.nTable}));return t(i).filter(e).map((function(){var e=i.indexOf(this);return r[e]})).toArray()};
/**
 * Context selector for the API's context (i.e. the tables the API instance
 * refers to.
 *
 * @name    DataTable.Api#tables
 * @param {string|integer} [selector] Selector to pick which tables the iterator
 *   should operate on. If not given, all tables in the current context are
 *   used. This can be given as a jQuery selector (for example `':gt(0)'`) to
 *   select multiple tables or as an integer to select a single table.
 * @returns {DataTable.Api} Returns a new API instance if a selector is given.
 */i("tables()",(function(e){return e!==void 0&&e!==null?new n(__table_selector(e,this.context)):this}));i("table()",(function(e){var t=this.tables(e);var r=t.context;return r.length?new n(r[0]):t}));[["nodes","node","nTable"],["body","body","nTBody"],["header","header","nTHead"],["footer","footer","nTFoot"]].forEach((function(e){o("tables()."+e[0]+"()","table()."+e[1]+"()",(function(){return this.iterator("table",(function(t){return t[e[2]]}),1)}))}));[["header","aoHeader"],["footer","aoFooter"]].forEach((function(e){i("table()."+e[0]+".structure()",(function(t){var r=this.columns(t).indexes().flatten();var n=this.context[0];return _fnHeaderLayout(n,n[e[1]],r)}))}));o("tables().containers()","table().container()",(function(){return this.iterator("table",(function(e){return e.nTableWrapper}),1)}));i("tables().every()",(function(e){var t=this;return this.iterator("table",(function(r,n){e.call(t.table(n),n)}))}));i("caption()",(function(e,r){var n=this.context;if(e===void 0){var i=n[0].captionNode;return i&&n.length?i.innerHTML:null}return this.iterator("table",(function(n){var i=t(n.nTable);var o=t(n.captionNode);var l=t(n.nTableWrapper);if(!o.length){o=t("<caption/>").html(e);n.captionNode=o[0];if(!r){i.prepend(o);r=o.css("caption-side")}}o.html(e);if(r){o.css("caption-side",r);o[0]._captionSide=r}if(l.find("div.dataTables_scroll").length){var s=r==="top"?"Head":"Foot";l.find("div.dataTables_scroll"+s+" table").prepend(o)}else i.prepend(o)}),1)}));i("caption.node()",(function(){var e=this.context;return e.length?e[0].captionNode:null}));i("draw()",(function(e){return this.iterator("table",(function(t){if(e==="page")_fnDraw(t);else{typeof e==="string"&&(e=e!=="full-hold");_fnReDraw(t,e===false)}}))}));
/**
 * Set the current page.
 *
 * Note that if you attempt to show a page which does not exist, DataTables will
 * not throw an error, but rather reset the paging.
 *
 * @param {integer|string} action The paging action to take. This can be one of:
 *  * `integer` - The page index to jump to
 *  * `string` - An action to take:
 *    * `first` - Jump to first page.
 *    * `next` - Jump to the next page
 *    * `previous` - Jump to previous page
 *    * `last` - Jump to the last page.
 * @returns {DataTables.Api} this
 */i("page()",(function(e){return e===void 0?this.page.info().page:this.iterator("table",(function(t){_fnPageChange(t,e)}))}));i("page.info()",(function(){if(this.context.length!==0){var e=this.context[0],t=e._iDisplayStart,r=e.oFeatures.bPaginate?e._iDisplayLength:-1,n=e.fnRecordsDisplay(),i=r===-1;return{page:i?0:Math.floor(t/r),pages:i?1:Math.ceil(n/r),start:t,end:e.fnDisplayEnd(),length:r,recordsTotal:e.fnRecordsTotal(),recordsDisplay:n,serverSide:_fnDataSource(e)==="ssp"}}}));
/**
 * Set the current page length.
 *
 * @param {integer} Page length to set. Use `-1` to show all records.
 * @returns {DataTables.Api} this
 */i("page.len()",(function(e){return e===void 0?this.context.length!==0?this.context[0]._iDisplayLength:void 0:this.iterator("table",(function(t){_fnLengthChange(t,e)}))}));var __reload=function(e,t,r){if(r){var i=new n(e);i.one("draw",(function(){r(i.ajax.json())}))}if(_fnDataSource(e)=="ssp")_fnReDraw(e,t);else{_fnProcessingDisplay(e,true);var o=e.jqXHR;o&&o.readyState!==4&&o.abort();_fnBuildAjax(e,{},(function(r){_fnClearTable(e);var n=_fnAjaxDataSrc(e,r);for(var i=0,o=n.length;i<o;i++)_fnAddData(e,n[i]);_fnReDraw(e,t);_fnInitComplete(e);_fnProcessingDisplay(e,false)}))}};i("ajax.json()",(function(){var e=this.context;if(e.length>0)return e[0].json}));i("ajax.params()",(function(){var e=this.context;if(e.length>0)return e[0].oAjaxData}));
/**
 * Reload tables from the Ajax data source. Note that this function will
 * automatically re-draw the table when the remote data has been loaded.
 *
 * @param {boolean} [reset=true] Reset (default) or hold the current paging
 *   position. A full re-sort and re-filter is performed when this method is
 *   called, which is why the pagination reset is the default action.
 * @returns {DataTables.Api} this
 */i("ajax.reload()",(function(e,t){return this.iterator("table",(function(r){__reload(r,t===false,e)}))}));
/**
 * Set the Ajax URL. Note that this will set the URL for all tables in the
 * current context.
 *
 * @param {string} url URL to set.
 * @returns {DataTables.Api} this
 */i("ajax.url()",(function(e){var r=this.context;if(e===void 0){if(r.length===0)return;r=r[0];return t.isPlainObject(r.ajax)?r.ajax.url:r.ajax}return this.iterator("table",(function(r){t.isPlainObject(r.ajax)?r.ajax.url=e:r.ajax=e}))}));
/**
 * Load data from the newly set Ajax URL. Note that this method is only
 * available when `ajax.url()` is used to set a URL. Additionally, this method
 * has the same effect as calling `ajax.reload()` but is provided for
 * convenience when setting a new URL. Like `ajax.reload()` it will
 * automatically redraw the table once the remote data has been loaded.
 *
 * @returns {DataTables.Api} this
 */i("ajax.url().load()",(function(e,t){return this.iterator("table",(function(r){__reload(r,t===false,e)}))}));var _selector_run=function(e,t,n,i,o){var l,s,u,f,c,d,p=[],v=typeof t;t&&v!=="string"&&v!=="function"&&t.length!==void 0||(t=[t]);for(u=0,f=t.length;u<f;u++){s=t[u]&&t[u].split&&!t[u].match(/[[(:]/)?t[u].split(","):[t[u]];for(c=0,d=s.length;c<d;c++){l=n(typeof s[c]==="string"?s[c].trim():s[c]);l=l.filter((function(e){return e!==null&&e!==void 0}));l&&l.length&&(p=p.concat(l))}}var h=r.selector[e];if(h.length)for(u=0,f=h.length;u<f;u++)p=h[u](i,o,p);return _unique(p)};var _selector_opts=function(e){e||(e={});e.filter&&e.search===void 0&&(e.search=e.filter);return t.extend({search:"none",order:"current",page:"all"},e)};var _selector_first=function(e){var t=new n(e.context[0]);e.length&&t.push(e[0]);t.selector=e.selector;t.length&&t[0].length>1&&t[0].splice(1);return t};var _selector_row_indexes=function(e,t){var r,n,i,o=[],l=e.aiDisplay,s=e.aiDisplayMaster;var u=t.search,f=t.order,c=t.page;if(_fnDataSource(e)=="ssp")return u==="removed"?[]:_range(0,s.length);if(c=="current")for(r=e._iDisplayStart,n=e.fnDisplayEnd();r<n;r++)o.push(l[r]);else if(f=="current"||f=="applied"){if(u=="none")o=s.slice();else if(u=="applied")o=l.slice();else if(u=="removed"){var d={};for(r=0,n=l.length;r<n;r++)d[l[r]]=null;s.forEach((function(e){Object.prototype.hasOwnProperty.call(d,e)||o.push(e)}))}}else if(f=="index"||f=="original"){for(r=0,n=e.aoData.length;r<n;r++)if(e.aoData[r])if(u=="none")o.push(r);else{i=l.indexOf(r);(i===-1&&u=="removed"||i>=0&&u=="applied")&&o.push(r)}}else if(typeof f==="number"){var p=_fnSort(e,f,"asc");if(u==="none")o=p;else for(r=0;r<p.length;r++){i=l.indexOf(p[r]);(i===-1&&u=="removed"||i>=0&&u=="applied")&&o.push(p[r])}}return o};var __row_selector=function(e,r,n){var i;var run=function(r){var o=_intVal(r);var l=e.aoData;if(o!==null&&!n)return[o];i||(i=_selector_row_indexes(e,n));if(o!==null&&i.indexOf(o)!==-1)return[o];if(r===null||r===void 0||r==="")return i;if(typeof r==="function")return i.map((function(e){var t=l[e];return r(e,t._aData,t.nTr)?e:null}));if(r.nodeName){var s=r._DT_RowIndex;var u=r._DT_CellIndex;if(s!==void 0)return l[s]&&l[s].nTr===r?[s]:[];if(u)return l[u.row]&&l[u.row].nTr===r.parentNode?[u.row]:[];var f=t(r).closest("*[data-dt-row]");return f.length?[f.data("dt-row")]:[]}if(typeof r==="string"&&r.charAt(0)==="#"){var c=e.aIds[r.replace(/^#/,"")];if(c!==void 0)return[c.idx]}var d=_removeEmpty(_pluck_order(e.aoData,i,"nTr"));return t(d).filter(r).map((function(){return this._DT_RowIndex})).toArray()};var o=_selector_run("row",r,run,e,n);n.order!=="current"&&n.order!=="applied"||_fnSortDisplay(e,o);return o};i("rows()",(function(e,r){if(e===void 0)e="";else if(t.isPlainObject(e)){r=e;e=""}r=_selector_opts(r);var n=this.iterator("table",(function(t){return __row_selector(t,e,r)}),1);n.selector.rows=e;n.selector.opts=r;return n}));i("rows().nodes()",(function(){return this.iterator("row",(function(e,t){return e.aoData[t].nTr||void 0}),1)}));i("rows().data()",(function(){return this.iterator(true,"rows",(function(e,t){return _pluck_order(e.aoData,t,"_aData")}),1)}));o("rows().cache()","row().cache()",(function(e){return this.iterator("row",(function(t,r){var n=t.aoData[r];return e==="search"?n._aFilterData:n._aSortData}),1)}));o("rows().invalidate()","row().invalidate()",(function(e){return this.iterator("row",(function(t,r){_fnInvalidate(t,r,e)}))}));o("rows().indexes()","row().index()",(function(){return this.iterator("row",(function(e,t){return t}),1)}));o("rows().ids()","row().id()",(function(e){var t=[];var r=this.context;for(var i=0,o=r.length;i<o;i++)for(var l=0,s=this[i].length;l<s;l++){var u=r[i].rowIdFn(r[i].aoData[this[i][l]]._aData);t.push((e===true?"#":"")+u)}return new n(r,t)}));o("rows().remove()","row().remove()",(function(){this.iterator("row",(function(e,t){var r=e.aoData;var n=r[t];var i=e.aiDisplayMaster.indexOf(t);i!==-1&&e.aiDisplayMaster.splice(i,1);e._iRecordsDisplay>0&&e._iRecordsDisplay--;_fnLengthOverflow(e);var o=e.rowIdFn(n._aData);o!==void 0&&delete e.aIds[o];r[t]=null}));return this}));i("rows.add()",(function(e){var t=this.iterator("table",(function(t){var r,n,i;var o=[];for(n=0,i=e.length;n<i;n++){r=e[n];r.nodeName&&r.nodeName.toUpperCase()==="TR"?o.push(_fnAddTr(t,r)[0]):o.push(_fnAddData(t,r))}return o}),1);var r=this.rows(-1);r.pop();_fnArrayApply(r,t);return r}));i("row()",(function(e,t){return _selector_first(this.rows(e,t))}));i("row().data()",(function(e){var t=this.context;if(e===void 0)return t.length&&this.length&&this[0].length?t[0].aoData[this[0]]._aData:void 0;var r=t[0].aoData[this[0]];r._aData=e;Array.isArray(e)&&r.nTr&&r.nTr.id&&m(t[0].rowId)(e,r.nTr.id);_fnInvalidate(t[0],this[0],"data");return this}));i("row().node()",(function(){var e=this.context;if(e.length&&this.length&&this[0].length){var t=e[0].aoData[this[0]];if(t&&t.nTr)return t.nTr}return null}));i("row.add()",(function(e){e instanceof t&&e.length&&(e=e[0]);var r=this.iterator("table",(function(t){return e.nodeName&&e.nodeName.toUpperCase()==="TR"?_fnAddTr(t,e)[0]:_fnAddData(t,e)}));return this.row(r[0])}));t(document).on("plugin-init.dt",(function(e,t){var r=new n(t);r.on("stateSaveParams.DT",(function(e,t,r){var n=t.rowIdFn;var i=t.aiDisplayMaster;var o=[];for(var l=0;l<i.length;l++){var s=i[l];var u=t.aoData[s];u._detailsShow&&o.push("#"+n(u._aData))}r.childRows=o}));r.on("stateLoaded.DT",(function(e,t,n){__details_state_load(r,n)}));__details_state_load(r,r.state.loaded())}));var __details_state_load=function(e,t){t&&t.childRows&&e.rows(t.childRows.map((function(e){return e.replace(/([^:\\]*(?:\\.[^:\\]*)*):/g,"$1\\:")}))).every((function(){_fnCallbackFire(e.settings()[0],null,"requestChild",[this])}))};var __details_add=function(e,r,n,i){var o=[];var addRow=function(n,i){if(Array.isArray(n)||n instanceof t)for(var l=0,s=n.length;l<s;l++)addRow(n[l],i);else if(n.nodeName&&n.nodeName.toLowerCase()==="tr"){n.setAttribute("data-dt-row",r.idx);o.push(n)}else{var u=t("<tr><td></td></tr>").attr("data-dt-row",r.idx).addClass(i);t("td",u).addClass(i).html(n)[0].colSpan=_fnVisbleColumns(e);o.push(u[0])}};addRow(n,i);r._details&&r._details.detach();r._details=t(o);r._detailsShow&&r._details.insertAfter(r.nTr)};var S=DataTable.util.throttle((function(e){_fnSaveState(e[0])}),500);var __details_remove=function(e,r){var n=e.context;if(n.length){var i=n[0].aoData[r!==void 0?r:e[0]];if(i&&i._details){i._details.remove();i._detailsShow=void 0;i._details=void 0;t(i.nTr).removeClass("dt-hasChild");S(n)}}};var __details_display=function(e,r){var n=e.context;if(n.length&&e.length){var i=n[0].aoData[e[0]];if(i._details){i._detailsShow=r;if(r){i._details.insertAfter(i.nTr);t(i.nTr).addClass("dt-hasChild")}else{i._details.detach();t(i.nTr).removeClass("dt-hasChild")}_fnCallbackFire(n[0],null,"childRow",[r,e.row(e[0])]);__details_events(n[0]);S(n)}}};var __details_events=function(e){var r=new n(e);var i=".dt.DT_details";var o="draw"+i;var l="column-sizing"+i;var s="destroy"+i;var u=e.aoData;r.off(o+" "+l+" "+s);if(_pluck(u,"_details").length>0){r.on(o,(function(t,n){e===n&&r.rows({page:"current"}).eq(0).each((function(e){var t=u[e];t._detailsShow&&t._details.insertAfter(t.nTr)}))}));r.on(l,(function(r,n){if(e===n){var i,o=_fnVisbleColumns(n);for(var l=0,s=u.length;l<s;l++){i=u[l];i&&i._details&&i._details.each((function(){var e=t(this).children("td");e.length==1&&e.attr("colspan",o)}))}}}));r.on(s,(function(t,n){if(e===n)for(var i=0,o=u.length;i<o;i++)u[i]&&u[i]._details&&__details_remove(r,i)}))}};var w="";var x=w+"row().child";var T=x+"()";i(T,(function(e,t){var r=this.context;if(e===void 0)return r.length&&this.length&&r[0].aoData[this[0]]?r[0].aoData[this[0]]._details:void 0;e===true?this.child.show():e===false?__details_remove(this):r.length&&this.length&&__details_add(r[0],r[0].aoData[this[0]],e,t);return this}));i([x+".show()",T+".show()"],(function(){__details_display(this,true);return this}));i([x+".hide()",T+".hide()"],(function(){__details_display(this,false);return this}));i([x+".remove()",T+".remove()"],(function(){__details_remove(this);return this}));i(x+".isShown()",(function(){var e=this.context;return e.length&&this.length&&e[0].aoData[this[0]]&&e[0].aoData[this[0]]._detailsShow||false}));var A=/^([^:]+)?:(name|title|visIdx|visible)$/;var __columnData=function(e,t,r,n,i,o){var l=[];for(var s=0,u=i.length;s<u;s++)l.push(_fnGetCellData(e,i[s],t,o));return l};var __column_header=function(e,t,r){var n=e.aoHeader;var i=r!==void 0?r:e.bSortCellsTop?0:n.length-1;return n[i][t].cell};var __column_selector=function(e,r,n){var i=e.aoColumns,o=_pluck(i,"sName"),l=_pluck(i,"sTitle"),s=DataTable.util.get("[].[].cell")(e.aoHeader),u=_unique(_flatten([],s));var run=function(r){var s=_intVal(r);if(r==="")return _range(i.length);if(s!==null)return[s>=0?s:i.length+s];if(typeof r==="function"){var f=_selector_row_indexes(e,n);return i.map((function(t,n){return r(n,__columnData(e,n,0,0,f),__column_header(e,n))?n:null}))}var c=typeof r==="string"?r.match(A):"";if(c)switch(c[2]){case"visIdx":case"visible":if(c[1]&&c[1].match(/^\d+$/)){var d=parseInt(c[1],10);if(d<0){var p=i.map((function(e,t){return e.bVisible?t:null}));return[p[p.length+d]]}return[_fnVisibleToColumnIndex(e,d)]}return i.map((function(e,r){return e.bVisible?c[1]?t(u[r]).filter(c[1]).length>0?r:null:r:null}));case"name":return o.map((function(e,t){return e===c[1]?t:null}));case"title":return l.map((function(e,t){return e===c[1]?t:null}));default:return[]}if(r.nodeName&&r._DT_CellIndex)return[r._DT_CellIndex.column];var v=t(u).filter(r).map((function(){return _fnColumnsFromHeader(this)})).toArray().sort((function(e,t){return e-t}));if(v.length||!r.nodeName)return v;var h=t(r).closest("*[data-dt-column]");return h.length?[h.data("dt-column")]:[]};return _selector_run("column",r,run,e,n)};var __setColumnVis=function(e,r,n){var i,o,l,s,u=e.aoColumns,f=u[r],c=e.aoData;if(n===void 0)return f.bVisible;if(f.bVisible===n)return false;if(n){var d=_pluck(u,"bVisible").indexOf(true,r+1);for(o=0,l=c.length;o<l;o++)if(c[o]){s=c[o].nTr;i=c[o].anCells;s&&s.insertBefore(i[r],i[d]||null)}}else t(_pluck(e.aoData,"anCells",r)).detach();f.bVisible=n;_colGroup(e);return true};i("columns()",(function(e,r){if(e===void 0)e="";else if(t.isPlainObject(e)){r=e;e=""}r=_selector_opts(r);var n=this.iterator("table",(function(t){return __column_selector(t,e,r)}),1);n.selector.cols=e;n.selector.opts=r;return n}));o("columns().header()","column().header()",(function(e){return this.iterator("column",(function(t,r){return __column_header(t,r,e)}),1)}));o("columns().footer()","column().footer()",(function(e){return this.iterator("column",(function(t,r){var n=t.aoFooter;return n.length?t.aoFooter[e!==void 0?e:0][r].cell:null}),1)}));o("columns().data()","column().data()",(function(){return this.iterator("column-rows",__columnData,1)}));o("columns().render()","column().render()",(function(e){return this.iterator("column-rows",(function(t,r,n,i,o){return __columnData(t,r,n,i,o,e)}),1)}));o("columns().dataSrc()","column().dataSrc()",(function(){return this.iterator("column",(function(e,t){return e.aoColumns[t].mData}),1)}));o("columns().cache()","column().cache()",(function(e){return this.iterator("column-rows",(function(t,r,n,i,o){return _pluck_order(t.aoData,o,e==="search"?"_aFilterData":"_aSortData",r)}),1)}));o("columns().init()","column().init()",(function(){return this.iterator("column",(function(e,t){return e.aoColumns[t]}),1)}));o("columns().nodes()","column().nodes()",(function(){return this.iterator("column-rows",(function(e,t,r,n,i){return _pluck_order(e.aoData,i,"anCells",t)}),1)}));o("columns().titles()","column().title()",(function(e,r){return this.iterator("column",(function(n,i){if(typeof e==="number"){r=e;e=void 0}var o=t("span.dt-column-title",this.column(i).header(r));if(e!==void 0){o.html(e);return this}return o.html()}),1)}));o("columns().types()","column().type()",(function(){return this.iterator("column",(function(e,t){var r=e.aoColumns[t].sType;r||_fnColumnTypes(e);return r}),1)}));o("columns().visible()","column().visible()",(function(e,r){var n=this;var i=[];var o=this.iterator("column",(function(t,r){if(e===void 0)return t.aoColumns[r].bVisible;__setColumnVis(t,r,e)&&i.push(r)}));e!==void 0&&this.iterator("table",(function(o){_fnDrawHead(o,o.aoHeader);_fnDrawHead(o,o.aoFooter);o.aiDisplay.length||t(o.nTBody).find("td[colspan]").attr("colspan",_fnVisbleColumns(o));_fnSaveState(o);n.iterator("column",(function(t,n){i.includes(n)&&_fnCallbackFire(t,null,"column-visibility",[t,n,e,r])}));i.length&&(r===void 0||r)&&n.columns.adjust()}));return o}));o("columns().widths()","column().width()",(function(){var e=this.columns(":visible").count();var r=t("<tr>").html("<td>"+Array(e).join("</td><td>")+"</td>");t(this.table().body()).append(r);var n=r.children().map((function(){return t(this).outerWidth()}));r.remove();return this.iterator("column",(function(e,t){var r=_fnColumnIndexToVisible(e,t);return r!==null?n[r]:0}),1)}));o("columns().indexes()","column().index()",(function(e){return this.iterator("column",(function(t,r){return e==="visible"?_fnColumnIndexToVisible(t,r):r}),1)}));i("columns.adjust()",(function(){return this.iterator("table",(function(e){e.containerWidth=-1;_fnAdjustColumnSizing(e)}),1)}));i("column.index()",(function(e,t){if(this.context.length!==0){var r=this.context[0];if(e==="fromVisible"||e==="toData")return _fnVisibleToColumnIndex(r,t);if(e==="fromData"||e==="toVisible")return _fnColumnIndexToVisible(r,t)}}));i("column()",(function(e,t){return _selector_first(this.columns(e,t))}));var __cell_selector=function(e,r,n){var i=e.aoData;var o=_selector_row_indexes(e,n);var l=_removeEmpty(_pluck_order(i,o,"anCells"));var s=t(_flatten([],l));var u;var f=e.aoColumns.length;var c,d,p,v,h,g;var run=function(r){var n=typeof r==="function";if(r===null||r===void 0||n){c=[];for(d=0,p=o.length;d<p;d++){u=o[d];for(v=0;v<f;v++){h={row:u,column:v};if(n){g=i[u];r(h,_fnGetCellData(e,u,v),g.anCells?g.anCells[v]:null)&&c.push(h)}else c.push(h)}}return c}if(t.isPlainObject(r))return r.column!==void 0&&r.row!==void 0&&o.indexOf(r.row)!==-1?[r]:[];var l=s.filter(r).map((function(e,t){return{row:t._DT_CellIndex.row,column:t._DT_CellIndex.column}})).toArray();if(l.length||!r.nodeName)return l;g=t(r).closest("*[data-dt-row]");return g.length?[{row:g.data("dt-row"),column:g.data("dt-column")}]:[]};return _selector_run("cell",r,run,e,n)};i("cells()",(function(e,r,n){if(t.isPlainObject(e))if(e.row===void 0){n=e;e=null}else{n=r;r=null}if(t.isPlainObject(r)){n=r;r=null}if(r===null||r===void 0)return this.iterator("table",(function(t){return __cell_selector(t,e,_selector_opts(n))}));var i=n?{page:n.page,order:n.order,search:n.search}:{};var o=this.columns(r,i);var l=this.rows(e,i);var s,u,f,c;var d=this.iterator("table",(function(e,t){var r=[];for(s=0,u=l[t].length;s<u;s++)for(f=0,c=o[t].length;f<c;f++)r.push({row:l[t][s],column:o[t][f]});return r}),1);var p=n&&n.selected?this.cells(d,n):d;t.extend(p.selector,{cols:r,rows:e,opts:n});return p}));o("cells().nodes()","cell().node()",(function(){return this.iterator("cell",(function(e,t,r){var n=e.aoData[t];return n&&n.anCells?n.anCells[r]:void 0}),1)}));i("cells().data()",(function(){return this.iterator("cell",(function(e,t,r){return _fnGetCellData(e,t,r)}),1)}));o("cells().cache()","cell().cache()",(function(e){e=e==="search"?"_aFilterData":"_aSortData";return this.iterator("cell",(function(t,r,n){return t.aoData[r][e][n]}),1)}));o("cells().render()","cell().render()",(function(e){return this.iterator("cell",(function(t,r,n){return _fnGetCellData(t,r,n,e)}),1)}));o("cells().indexes()","cell().index()",(function(){return this.iterator("cell",(function(e,t,r){return{row:t,column:r,columnVisible:_fnColumnIndexToVisible(e,r)}}),1)}));o("cells().invalidate()","cell().invalidate()",(function(e){return this.iterator("cell",(function(t,r,n){_fnInvalidate(t,r,e,n)}))}));i("cell()",(function(e,t,r){return _selector_first(this.cells(e,t,r))}));i("cell().data()",(function(e){var t=this.context;var r=this[0];if(e===void 0)return t.length&&r.length?_fnGetCellData(t[0],r[0].row,r[0].column):void 0;_fnSetCellData(t[0],r[0].row,r[0].column,e);_fnInvalidate(t[0],r[0].row,"data",r[0].column);return this}));
/**
 * Get current ordering (sorting) that has been applied to the table.
 *
 * @returns {array} 2D array containing the sorting information for the first
 *   table in the current context. Each element in the parent array represents
 *   a column being sorted upon (i.e. multi-sorting with two columns would have
 *   2 inner arrays). The inner arrays may have 2 or 3 elements. The first is
 *   the column index that the sorting condition applies to, the second is the
 *   direction of the sort (`desc` or `asc`) and, optionally, the third is the
 *   index of the sorting order from the `column.sorting` initialisation array.
 */
/**
 * Set the ordering for the table.
 *
 * @param {integer} order Column index to sort upon.
 * @param {string} direction Direction of the sort to be applied (`asc` or `desc`)
 * @returns {DataTables.Api} this
 */
/**
 * Set the ordering for the table.
 *
 * @param {array} order 1D array of sorting information to be applied.
 * @param {array} [...] Optional additional sorting conditions
 * @returns {DataTables.Api} this
 */
/**
 * Set the ordering for the table.
 *
 * @param {array} order 2D array of sorting information to be applied.
 * @returns {DataTables.Api} this
 */i("order()",(function(e,t){var r=this.context;var n=Array.prototype.slice.call(arguments);if(e===void 0)return r.length!==0?r[0].aaSorting:void 0;typeof e==="number"?e=[[e,t]]:n.length>1&&(e=n);return this.iterator("table",(function(t){t.aaSorting=Array.isArray(e)?e.slice():e}))}));
/**
 * Attach a sort listener to an element for a given column
 *
 * @param {node|jQuery|string} node Identifier for the element(s) to attach the
 *   listener to. This can take the form of a single DOM node, a jQuery
 *   collection of nodes or a jQuery selector which will identify the node(s).
 * @param {integer} column the column that a click on this node will sort on
 * @param {function} [callback] callback function when sort is run
 * @returns {DataTables.Api} this
 */i("order.listener()",(function(e,t,r){return this.iterator("table",(function(n){_fnSortAttachListener(n,e,{},t,r)}))}));i("order.fixed()",(function(e){if(!e){var r=this.context;var n=r.length?r[0].aaSortingFixed:void 0;return Array.isArray(n)?{pre:n}:n}return this.iterator("table",(function(r){r.aaSortingFixed=t.extend(true,{},e)}))}));i(["columns().order()","column().order()"],(function(e){var t=this;return e?this.iterator("table",(function(r,n){r.aaSorting=t[n].map((function(t){return[t,e]}))})):this.iterator("column",(function(e,t){var r=_fnSortFlatten(e);for(var n=0,i=r.length;n<i;n++)if(r[n].col===t)return r[n].dir;return null}),1)}));o("columns().orderable()","column().orderable()",(function(e){return this.iterator("column",(function(t,r){var n=t.aoColumns[r];return e?n.asSorting:n.bSortable}),1)}));i("processing()",(function(e){return this.iterator("table",(function(t){_fnProcessingDisplay(t,e)}))}));i("search()",(function(e,r,n,i){var o=this.context;return e===void 0?o.length!==0?o[0].oPreviousSearch.search:void 0:this.iterator("table",(function(o){o.oFeatures.bFilter&&_fnFilterComplete(o,typeof r==="object"?t.extend(o.oPreviousSearch,r,{search:e}):t.extend(o.oPreviousSearch,{search:e,regex:r!==null&&r,smart:n===null||n,caseInsensitive:i===null||i}))}))}));i("search.fixed()",(function(e,t){var r=this.iterator(true,"table",(function(r){var n=r.searchFixed;if(!e)return Object.keys(n);if(t===void 0)return n[e];t===null?delete n[e]:n[e]=t;return this}));return e!==void 0&&t===void 0?r[0]:r}));o("columns().search()","column().search()",(function(e,r,n,i){return this.iterator("column",(function(o,l){var s=o.aoPreSearchCols;if(e===void 0)return s[l].search;if(o.oFeatures.bFilter){typeof r==="object"?t.extend(s[l],r,{search:e}):t.extend(s[l],{search:e,regex:r!==null&&r,smart:n===null||n,caseInsensitive:i===null||i});_fnFilterComplete(o,o.oPreviousSearch)}}))}));i(["columns().search.fixed()","column().search.fixed()"],(function(e,t){var r=this.iterator(true,"column",(function(r,n){var i=r.aoColumns[n].searchFixed;if(!e)return Object.keys(i);if(t===void 0)return i[e];t===null?delete i[e]:i[e]=t;return this}));return e!==void 0&&t===void 0?r[0]:r}));i("state()",(function(e,r){if(!e)return this.context.length?this.context[0].oSavedState:null;var n=t.extend(true,{},e);return this.iterator("table",(function(e){r!==false&&(n.time=+new Date+100);_fnImplementState(e,n,(function(){}))}))}));i("state.clear()",(function(){return this.iterator("table",(function(e){e.fnStateSaveCallback.call(e.oInstance,e,{})}))}));i("state.loaded()",(function(){return this.context.length?this.context[0].oLoadedState:null}));i("state.save()",(function(){return this.iterator("table",(function(e){_fnSaveState(e)}))}));var F;var I;DataTable.use=function(e,r){var n=typeof e==="string"?r:e;var i=typeof r==="string"?r:e;if(n===void 0&&typeof i==="string")switch(i){case"lib":case"jq":return t;case"win":return window;case"datetime":return DataTable.DateTime;case"luxon":return N;case"moment":return j;case"bootstrap":return F||window.bootstrap;case"foundation":return I||window.Foundation;default:return null}if(i==="lib"||i==="jq"||n&&n.fn&&n.fn.jquery)t=n;else if(i==="win"||n&&n.document){window=n;document=n.document}else i==="datetime"||n&&n.type==="DateTime"?DataTable.DateTime=n:i==="luxon"||n&&n.FixedOffsetZone?N=n:i==="moment"||n&&n.isMoment?j=n:i==="bootstrap"||n&&n.Modal&&n.Modal.NAME==="modal"?F=n:(i==="foundation"||n&&n.Reveal)&&(I=n)};
/**
 * CommonJS factory function pass through. This will check if the arguments
 * given are a window object or a jQuery object. If so they are set
 * accordingly.
 * @param {*} root Window
 * @param {*} jq jQUery
 * @returns {boolean} Indicator
 */DataTable.factory=function(e,r){var n=false;if(e&&e.document){window=e;document=e.document}if(r&&r.fn&&r.fn.jquery){t=r;n=true}return n};
/**
 * Provide a common method for plug-ins to check the version of DataTables being
 * used, in order to ensure compatibility.
 *
 *  @param {string} version Version string to check for, in the format "X.Y.Z".
 *    Note that the formats "X" and "X.Y" are also acceptable.
 *  @param {string} [version2=current DataTables version] As above, but optional.
 *   If not given the current DataTables version will be used.
 *  @returns {boolean} true if this version of DataTables is greater or equal to
 *    the required version, or false if this version of DataTales is not
 *    suitable
 *  @static
 *  @dtopt API-Static
 *
 *  @example
 *    alert( $.fn.dataTable.versionCheck( '1.9.0' ) );
 */DataTable.versionCheck=function(e,t){var r=t?t.split("."):DataTable.version.split(".");var n=e.split(".");var i,o;for(var l=0,s=n.length;l<s;l++){i=parseInt(r[l],10)||0;o=parseInt(n[l],10)||0;if(i!==o)return i>o}return true};
/**
 * Check if a `<table>` node is a DataTable table already or not.
 *
 *  @param {node|jquery|string} table Table node, jQuery object or jQuery
 *      selector for the table to test. Note that if more than more than one
 *      table is passed on, only the first will be checked
 *  @returns {boolean} true the table given is a DataTable, or false otherwise
 *  @static
 *  @dtopt API-Static
 *
 *  @example
 *    if ( ! $.fn.DataTable.isDataTable( '#example' ) ) {
 *      $('#example').dataTable();
 *    }
 */DataTable.isDataTable=function(e){var r=t(e).get(0);var n=false;if(e instanceof DataTable.Api)return true;t.each(DataTable.settings,(function(e,i){var o=i.nScrollHead?t("table",i.nScrollHead)[0]:null;var l=i.nScrollFoot?t("table",i.nScrollFoot)[0]:null;i.nTable!==r&&o!==r&&l!==r||(n=true)}));return n};
/**
 * Get all DataTable tables that have been initialised - optionally you can
 * select to get only currently visible tables.
 *
 *  @param {boolean} [visible=false] Flag to indicate if you want all (default)
 *    or visible tables only.
 *  @returns {array} Array of `table` nodes (not DataTable instances) which are
 *    DataTables
 *  @static
 *  @dtopt API-Static
 *
 *  @example
 *    $.each( $.fn.dataTable.tables(true), function () {
 *      $(table).DataTable().columns.adjust();
 *    } );
 */DataTable.tables=function(e){var r=false;if(t.isPlainObject(e)){r=e.api;e=e.visible}var i=DataTable.settings.filter((function(r){return!!(!e||e&&t(r.nTable).is(":visible"))})).map((function(e){return e.nTable}));return r?new n(i):i};
/**
 * Convert from camel case parameters to Hungarian notation. This is made public
 * for the extensions to provide the same ability as DataTables core to accept
 * either the 1.9 style Hungarian notation, or the 1.10+ style camelCase
 * parameters.
 *
 *  @param {object} src The model object which holds all parameters that can be
 *    mapped.
 *  @param {object} user The object to convert from camel case to Hungarian.
 *  @param {boolean} force When set to `true`, properties which already have a
 *    Hungarian value in the `user` object will be overwritten. Otherwise they
 *    won't be.
 */DataTable.camelToHungarian=_fnCamelToHungarian;i("$()",(function(e,r){var n=this.rows(r).nodes(),i=t(n);return t([].concat(i.filter(e).toArray(),i.find(e).toArray()))}));t.each(["on","one","off"],(function(e,r){i(r+"()",(function(){var e=Array.prototype.slice.call(arguments);e[0]=e[0].split(/\s/).map((function(e){return e.match(/\.dt\b/)?e:e+".dt"})).join(" ");var n=t(this.tables().nodes());n[r].apply(n,e);return this}))}));i("clear()",(function(){return this.iterator("table",(function(e){_fnClearTable(e)}))}));i("error()",(function(e){return this.iterator("table",(function(t){_fnLog(t,0,e)}))}));i("settings()",(function(){return new n(this.context,this.context)}));i("init()",(function(){var e=this.context;return e.length?e[0].oInit:null}));i("data()",(function(){return this.iterator("table",(function(e){return _pluck(e.aoData,"_aData")})).flatten()}));i("trigger()",(function(e,t,r){return this.iterator("table",(function(n){return _fnCallbackFire(n,null,e,t,r)})).flatten()}));i("ready()",(function(e){var t=this.context;return e?this.tables().every((function(){var t=this;this.context[0]._bInitComplete?e.call(t):this.on("init.dt.DT",(function(){e.call(t)}))})):t.length?t[0]._bInitComplete||false:null}));i("destroy()",(function(e){e=e||false;return this.iterator("table",(function(r){var i=r.oClasses;var o=r.nTable;var l=r.nTBody;var s=r.nTHead;var u=r.nTFoot;var f=t(o);var c=t(l);var d=t(r.nTableWrapper);var p=r.aoData.map((function(e){return e?e.nTr:null}));var v=i.order;r.bDestroying=true;_fnCallbackFire(r,"aoDestroyCallback","destroy",[r],true);e||new n(r).columns().visible(true);r.resizeObserver&&r.resizeObserver.disconnect();d.off(".DT").find(":not(tbody *)").off(".DT");t(window).off(".DT-"+r.sInstance);if(o!=s.parentNode){f.children("thead").detach();f.append(s)}if(u&&o!=u.parentNode){f.children("tfoot").detach();f.append(u)}t(s).find("span.dt-column-order").remove();t(s).find("span.dt-column-title").each((function(){var e=t(this).html();t(this).parent().append(e);t(this).remove()}));r.colgroup.remove();r.aaSorting=[];r.aaSortingFixed=[];_fnSortingClasses(r);t(f).find("th, td").removeClass(t.map(DataTable.ext.type.className,(function(e){return e})).join(" "));t("th, td",s).removeClass(v.none+" "+v.canAsc+" "+v.canDesc+" "+v.isAsc+" "+v.isDesc).css("width","").removeAttr("data-dt-column").removeAttr("aria-sort");c.children().detach();c.append(p);var h=r.nTableWrapper.parentNode;var g=r.nTableWrapper.nextSibling;var m=e?"remove":"detach";f[m]();d[m]();if(!e&&h){h.insertBefore(o,g);f.css("width",r.sDestroyWidth).removeClass(i.table)}var _=DataTable.settings.indexOf(r);_!==-1&&DataTable.settings.splice(_,1)}))}));t.each(["column","row","cell"],(function(e,t){i(t+"s().every()",(function(e){var r=this.selector.opts;var n=this;var i;var o=0;return this.iterator("every",(function(l,s,u){i=n[t](s,r);t==="cell"?e.call(i,i[0][0].row,i[0][0].column,u,o):e.call(i,s,u,o);o++}))}))}));i("i18n()",(function(e,r,n){var i=this.context[0];var o=g(e)(i.oLanguage);o===void 0&&(o=r);t.isPlainObject(o)&&(o=n!==void 0&&o[n]!==void 0?o[n]:o._);return typeof o==="string"?o.replace("%d",n):o}));
/**
 * Version string for plug-ins to check compatibility. Allowed format is
 * `a.b.c-d` where: a:int, b:int, c:int, d:string(dev|beta|alpha). `d` is used
 * only for non-release builds. See https://semver.org/ for more information.
 *  @member
 *  @type string
 *  @default Version number
 */DataTable.version="2.2.2";
/**
 * Private data store, containing all of the settings objects that are
 * created for the tables on a given page.
 *
 * Note that the `DataTable.settings` object is aliased to
 * `jQuery.fn.dataTableExt` through which it may be accessed and
 * manipulated, or `jQuery.fn.dataTable.settings`.
 *  @member
 *  @type array
 *  @default []
 *  @private
 */DataTable.settings=[];DataTable.models={};DataTable.models.oSearch={caseInsensitive:true,search:"",regex:false,smart:true,return:false};DataTable.models.oRow={nTr:null,anCells:null,_aData:[],_aSortData:null,_aFilterData:null,_sFilterRow:null,src:null,idx:-1,displayData:null};DataTable.models.oColumn={idx:null,aDataSort:null,asSorting:null,bSearchable:null,bSortable:null,bVisible:null,_sManualType:null,_bAttrSrc:false,fnCreatedCell:null,fnGetData:null,fnSetData:null,mData:null,mRender:null,sClass:null,sContentPadding:null,sDefaultContent:null,sName:null,sSortDataType:"std",sSortingClass:null,sTitle:null,sType:null,sWidth:null,sWidthOrig:null,maxLenString:null,searchFixed:null};DataTable.defaults={aaData:null,aaSorting:[[0,"asc"]],aaSortingFixed:[],ajax:null,aLengthMenu:[10,25,50,100],aoColumns:null,aoColumnDefs:null,aoSearchCols:[],bAutoWidth:true,bDeferRender:true,bDestroy:false,bFilter:true,
/**
	 * Used only for compatiblity with DT1
	 * @deprecated
	 */
bInfo:true,
/**
	 * Used only for compatiblity with DT1
	 * @deprecated
	 */
bLengthChange:true,bPaginate:true,bProcessing:false,bRetrieve:false,bScrollCollapse:false,bServerSide:false,bSort:true,bSortMulti:true,bSortCellsTop:null,bSortClasses:true,bStateSave:false,fnCreatedRow:null,fnDrawCallback:null,fnFooterCallback:null,fnFormatNumber:function(e){return e.toString().replace(/\B(?=(\d{3})+(?!\d))/g,this.oLanguage.sThousands)},fnHeaderCallback:null,fnInfoCallback:null,fnInitComplete:null,fnPreDrawCallback:null,fnRowCallback:null,fnStateLoadCallback:function(e){try{return JSON.parse((e.iStateDuration===-1?sessionStorage:localStorage).getItem("DataTables_"+e.sInstance+"_"+location.pathname))}catch(e){return{}}},fnStateLoadParams:null,fnStateLoaded:null,fnStateSaveCallback:function(e,t){try{(e.iStateDuration===-1?sessionStorage:localStorage).setItem("DataTables_"+e.sInstance+"_"+location.pathname,JSON.stringify(t))}catch(e){}},fnStateSaveParams:null,iStateDuration:7200,iDisplayLength:10,iDisplayStart:0,iTabIndex:0,oClasses:{},oLanguage:{oAria:{orderable:": Activate to sort",orderableReverse:": Activate to invert sorting",orderableRemove:": Activate to remove sorting",paginate:{first:"First",last:"Last",next:"Next",previous:"Previous",number:""}},oPaginate:{sFirst:"«",sLast:"»",sNext:"›",sPrevious:"‹"},entries:{_:"entries",1:"entry"},sEmptyTable:"No data available in table",sInfo:"Showing _START_ to _END_ of _TOTAL_ _ENTRIES-TOTAL_",sInfoEmpty:"Showing 0 to 0 of 0 _ENTRIES-TOTAL_",sInfoFiltered:"(filtered from _MAX_ total _ENTRIES-MAX_)",sInfoPostFix:"",sDecimal:"",sThousands:",",sLengthMenu:"_MENU_ _ENTRIES_ per page",sLoadingRecords:"Loading...",sProcessing:"",sSearch:"Search:",
/**
		 * Assign a `placeholder` attribute to the search `input` element
		 *  @type string
		 *  @default 
		 *
		 *  @dtopt Language
		 *  @name DataTable.defaults.language.searchPlaceholder
		 */
sSearchPlaceholder:"",sUrl:"",sZeroRecords:"No matching records found"},orderDescReverse:true,oSearch:t.extend({},DataTable.models.oSearch),layout:{topStart:"pageLength",topEnd:"search",bottomStart:"info",bottomEnd:"paging"},sDom:null,searchDelay:null,sPaginationType:"",sScrollX:"",sScrollXInner:"",sScrollY:"",sServerMethod:"GET",renderer:null,rowId:"DT_RowId",caption:null,iDeferLoading:null};_fnHungarianMap(DataTable.defaults);DataTable.defaults.column={aDataSort:null,iDataSort:-1,ariaTitle:"",asSorting:["asc","desc",""],bSearchable:true,bSortable:true,bVisible:true,fnCreatedCell:null,mData:null,mRender:null,sCellType:"td",sClass:"",sContentPadding:"",sDefaultContent:null,sName:"",sSortDataType:"std",sTitle:null,sType:null,sWidth:null};_fnHungarianMap(DataTable.defaults.column);DataTable.models.oSettings={oFeatures:{bAutoWidth:null,bDeferRender:null,bFilter:null,
/**
		 * Used only for compatiblity with DT1
		 * @deprecated
		 */
bInfo:true,
/**
		 * Used only for compatiblity with DT1
		 * @deprecated
		 */
bLengthChange:true,bPaginate:null,bProcessing:null,bServerSide:null,bSort:null,bSortMulti:null,bSortClasses:null,bStateSave:null},oScroll:{bCollapse:null,iBarWidth:0,sX:null,
/**
		 * Width to expand the table to when using x-scrolling. Typically you
		 * should not need to use this.
		 * Note that this parameter will be set by the initialisation routine. To
		 * set a default use {@link DataTable.defaults}.
		 *  @deprecated
		 */
sXInner:null,sY:null},oLanguage:{fnInfoCallback:null},oBrowser:{bScrollbarLeft:false,barWidth:0},ajax:null,aanFeatures:[],aoData:[],aiDisplay:[],aiDisplayMaster:[],aIds:{},aoColumns:[],aoHeader:[],aoFooter:[],oPreviousSearch:{},searchFixed:{},aoPreSearchCols:[],aaSorting:null,aaSortingFixed:[],sDestroyWidth:0,aoRowCallback:[],aoHeaderCallback:[],aoFooterCallback:[],aoDrawCallback:[],aoRowCreatedCallback:[],aoPreDrawCallback:[],aoInitComplete:[],aoStateSaveParams:[],aoStateLoadParams:[],aoStateLoaded:[],sTableId:"",nTable:null,nTHead:null,nTFoot:null,nTBody:null,nTableWrapper:null,bInitialised:false,aoOpenRows:[],sDom:null,searchDelay:null,sPaginationType:"two_button",pagingControls:0,iStateDuration:0,aoStateSave:[],aoStateLoad:[],oSavedState:null,oLoadedState:null,bAjaxDataGet:true,jqXHR:null,json:void 0,oAjaxData:void 0,sServerMethod:null,fnFormatNumber:null,aLengthMenu:null,iDraw:0,bDrawing:false,iDrawError:-1,_iDisplayLength:10,_iDisplayStart:0,_iRecordsTotal:0,_iRecordsDisplay:0,oClasses:{},
/**
	 * Flag attached to the settings object so you can check in the draw
	 * callback if filtering has been done in the draw. Deprecated in favour of
	 * events.
	 *  @deprecated
	 */
bFiltered:false,
/**
	 * Flag attached to the settings object so you can check in the draw
	 * callback if sorting has been done in the draw. Deprecated in favour of
	 * events.
	 *  @deprecated
	 */
bSorted:false,bSortCellsTop:null,oInit:null,aoDestroyCallback:[],fnRecordsTotal:function(){return _fnDataSource(this)=="ssp"?this._iRecordsTotal*1:this.aiDisplayMaster.length},fnRecordsDisplay:function(){return _fnDataSource(this)=="ssp"?this._iRecordsDisplay*1:this.aiDisplay.length},fnDisplayEnd:function(){var e=this._iDisplayLength,t=this._iDisplayStart,r=t+e,n=this.aiDisplay.length,i=this.oFeatures,o=i.bPaginate;return i.bServerSide?o===false||e===-1?t+n:Math.min(t+e,this._iRecordsDisplay):!o||r>n||e===-1?n:r},oInstance:null,sInstance:null,iTabIndex:0,nScrollHead:null,nScrollFoot:null,aLastSort:[],oPlugins:{},rowIdFn:null,rowId:null,caption:"",captionNode:null,colgroup:null,deferLoading:null,typeDetect:true,resizeObserver:null,containerWidth:-1};var L=DataTable.ext.pager;t.extend(L,{simple:function(){return["previous","next"]},full:function(){return["first","previous","next","last"]},numbers:function(){return["numbers"]},simple_numbers:function(){return["previous","numbers","next"]},full_numbers:function(){return["first","previous","numbers","next","last"]},first_last:function(){return["first","last"]},first_last_numbers:function(){return["first","numbers","last"]},_numbers:_pagingNumbers,numbers_length:7});t.extend(true,DataTable.ext.renderer,{pagingButton:{_:function(e,r,n,i,o){var l=e.oClasses.paging;var s=[l.button];var u;i&&s.push(l.active);o&&s.push(l.disabled);u=r==="ellipsis"?t('<span class="ellipsis"></span>').html(n)[0]:t("<button>",{class:s.join(" "),role:"link",type:"button"}).html(n);return{display:u,clicker:u}}},pagingContainer:{_:function(e,t){return t}}});var _filterString=function(e,t){return function(r){if(_empty(r)||typeof r!=="string")return r;r=r.replace(s," ");e&&(r=_stripHtml(r));t&&(r=_normalize(r,false));return r}};function __mld(e,t,r,n,i){return j?e[t](i):N?e[r](i):n?e[n](i):e}var R=false;var N;var j;function resolveWindowLibs(){window.luxon&&!N&&(N=window.luxon);window.moment&&!j&&(j=window.moment)}function __mldObj(e,t,r){var n;resolveWindowLibs();if(j){n=j.utc(e,t,r,true);if(!n.isValid())return null}else if(N){n=t&&typeof e==="string"?N.DateTime.fromFormat(e,t):N.DateTime.fromISO(e);if(!n.isValid)return null;n=n.setLocale(r)}else if(t){R||alert("DataTables warning: Formatted date without Moment.js or Luxon - https://datatables.net/tn/17");R=true}else n=new Date(e);return n}function __mlHelper(e){return function(t,r,n,i){if(arguments.length===0){n="en";r=null;t=null}else if(arguments.length===1){n="en";r=t;t=null}else if(arguments.length===2){n=r;r=t;t=null}var o="datetime"+(r?"-"+r:"");DataTable.ext.type.order[o+"-pre"]||DataTable.type(o,{detect:function(e){return e===o&&o},order:{pre:function(e){return e.valueOf()}},className:"dt-right"});return function(l,s){if(l===null||l===void 0)if(i==="--now"){var u=new Date;l=new Date(Date.UTC(u.getFullYear(),u.getMonth(),u.getDate(),u.getHours(),u.getMinutes(),u.getSeconds()))}else l="";if(s==="type")return o;if(l==="")return s!=="sort"?"":__mldObj("0000-01-01 00:00:00",null,n);if(r!==null&&t===r&&s!=="sort"&&s!=="type"&&!(l instanceof Date))return l;var f=__mldObj(l,t,n);if(f===null)return l;if(s==="sort")return f;var c=r===null?__mld(f,"toDate","toJSDate","")[e]():__mld(f,"format","toFormat","toISOString",r);return s==="display"?_escapeHtml(c):c}}}var O=",";var P=".";if(window.Intl!==void 0)try{var k=(new Intl.NumberFormat).formatToParts(100000.1);for(var M=0;M<k.length;M++)k[M].type==="group"?O=k[M].value:k[M].type==="decimal"&&(P=k[M].value)}catch(e){}DataTable.datetime=function(e,t){var r="datetime-"+e;t||(t="en");DataTable.ext.type.order[r]||DataTable.type(r,{detect:function(n){var i=__mldObj(n,e,t);return!(n!==""&&!i)&&r},order:{pre:function(r){return __mldObj(r,e,t)||0}},className:"dt-right"})};DataTable.render={date:__mlHelper("toLocaleDateString"),datetime:__mlHelper("toLocaleString"),time:__mlHelper("toLocaleTimeString"),number:function(e,t,r,n,i){e!==null&&e!==void 0||(e=O);t!==null&&t!==void 0||(t=P);return{display:function(o){if(typeof o!=="number"&&typeof o!=="string")return o;if(o===""||o===null)return o;var l=o<0?"-":"";var s=parseFloat(o);var u=Math.abs(s);if(u>=1e11||u<1e-4&&u!==0){var f=s.toExponential(r).split(/e\+?/);return f[0]+" x 10<sup>"+f[1]+"</sup>"}if(isNaN(s))return _escapeHtml(o);s=s.toFixed(r);o=Math.abs(s);var c=parseInt(o,10);var d=r?t+(o-c).toFixed(r).substring(2):"";c===0&&parseFloat(d)===0&&(l="");return l+(n||"")+c.toString().replace(/\B(?=(\d{3})+(?!\d))/g,e)+d+(i||"")}}},text:function(){return{display:_escapeHtml,filter:_escapeHtml}}};var H=DataTable.ext.type;DataTable.type=function(e,t,r){if(!t)return{className:H.className[e],detect:H.detect.find((function(t){return t._name===e})),order:{pre:H.order[e+"-pre"],asc:H.order[e+"-asc"],desc:H.order[e+"-desc"]},render:H.render[e],search:H.search[e]};var setProp=function(t,r){H[t][e]=r};var setDetect=function(t){Object.defineProperty(t,"_name",{value:e});var r=H.detect.findIndex((function(t){return t._name===e}));r===-1?H.detect.unshift(t):H.detect.splice(r,1,t)};var setOrder=function(t){H.order[e+"-pre"]=t.pre;H.order[e+"-asc"]=t.asc;H.order[e+"-desc"]=t.desc};if(r===void 0){r=t;t=null}if(t==="className")setProp("className",r);else if(t==="detect")setDetect(r);else if(t==="order")setOrder(r);else if(t==="render")setProp("render",r);else if(t==="search")setProp("search",r);else if(!t){r.className&&setProp("className",r.className);r.detect!==void 0&&setDetect(r.detect);r.order&&setOrder(r.order);r.render!==void 0&&setProp("render",r.render);r.search!==void 0&&setProp("search",r.search)}};DataTable.types=function(){return H.detect.map((function(e){return e._name}))};var __diacriticSort=function(e,t){e=e!==null&&e!==void 0?e.toString().toLowerCase():"";t=t!==null&&t!==void 0?t.toString().toLowerCase():"";return e.localeCompare(t,navigator.languages[0]||navigator.language,{numeric:true,ignorePunctuation:true})};var __diacriticHtmlSort=function(e,t){e=_stripHtml(e);t=_stripHtml(t);return __diacriticSort(e,t)};DataTable.type("string",{detect:function(){return"string"},order:{pre:function(e){return _empty(e)&&typeof e!=="boolean"?"":typeof e==="string"?e.toLowerCase():e.toString?e.toString():""}},search:_filterString(false,true)});DataTable.type("string-utf8",{detect:{allOf:function(e){return true},oneOf:function(e){return!_empty(e)&&navigator.languages&&typeof e==="string"&&e.match(/[^\x00-\x7F]/)}},order:{asc:__diacriticSort,desc:function(e,t){return __diacriticSort(e,t)*-1}},search:_filterString(false,true)});DataTable.type("html",{detect:{allOf:function(e){return _empty(e)||typeof e==="string"&&e.indexOf("<")!==-1},oneOf:function(e){return!_empty(e)&&typeof e==="string"&&e.indexOf("<")!==-1}},order:{pre:function(e){return _empty(e)?"":e.replace?_stripHtml(e).trim().toLowerCase():e+""}},search:_filterString(true,true)});DataTable.type("html-utf8",{detect:{allOf:function(e){return _empty(e)||typeof e==="string"&&e.indexOf("<")!==-1},oneOf:function(e){return navigator.languages&&!_empty(e)&&typeof e==="string"&&e.indexOf("<")!==-1&&typeof e==="string"&&e.match(/[^\x00-\x7F]/)}},order:{asc:__diacriticHtmlSort,desc:function(e,t){return __diacriticHtmlSort(e,t)*-1}},search:_filterString(true,true)});DataTable.type("date",{className:"dt-type-date",detect:{allOf:function(e){if(e&&!(e instanceof Date)&&!c.test(e))return null;var t=Date.parse(e);return t!==null&&!isNaN(t)||_empty(e)},oneOf:function(e){return e instanceof Date||typeof e==="string"&&c.test(e)}},order:{pre:function(e){var t=Date.parse(e);return isNaN(t)?-Infinity:t}}});DataTable.type("html-num-fmt",{className:"dt-type-numeric",detect:{allOf:function(e,t){var r=t.oLanguage.sDecimal;return _htmlNumeric(e,r,true,false)},oneOf:function(e,t){var r=t.oLanguage.sDecimal;return _htmlNumeric(e,r,true,false)}},order:{pre:function(e,t){var r=t.oLanguage.sDecimal;return __numericReplace(e,r,u,p)}},search:_filterString(true,true)});DataTable.type("html-num",{className:"dt-type-numeric",detect:{allOf:function(e,t){var r=t.oLanguage.sDecimal;return _htmlNumeric(e,r,false,true)},oneOf:function(e,t){var r=t.oLanguage.sDecimal;return _htmlNumeric(e,r,false,false)}},order:{pre:function(e,t){var r=t.oLanguage.sDecimal;return __numericReplace(e,r,u)}},search:_filterString(true,true)});DataTable.type("num-fmt",{className:"dt-type-numeric",detect:{allOf:function(e,t){var r=t.oLanguage.sDecimal;return _isNumber(e,r,true,true)},oneOf:function(e,t){var r=t.oLanguage.sDecimal;return _isNumber(e,r,true,false)}},order:{pre:function(e,t){var r=t.oLanguage.sDecimal;return __numericReplace(e,r,p)}}});DataTable.type("num",{className:"dt-type-numeric",detect:{allOf:function(e,t){var r=t.oLanguage.sDecimal;return _isNumber(e,r,false,true)},oneOf:function(e,t){var r=t.oLanguage.sDecimal;return _isNumber(e,r,false,false)}},order:{pre:function(e,t){var r=t.oLanguage.sDecimal;return __numericReplace(e,r)}}});var __numericReplace=function(e,t,r,n){if(e!==0&&(!e||e==="-"))return-Infinity;var i=typeof e;if(i==="number"||i==="bigint")return e;t&&(e=_numToDecimal(e,t));if(e.replace){r&&(e=e.replace(r,""));n&&(e=e.replace(n,""))}return e*1};t.extend(true,DataTable.ext.renderer,{footer:{_:function(e,t,r){t.addClass(r.tfoot.cell)}},header:{_:function(e,r,n){r.addClass(n.thead.cell);e.oFeatures.bSort||r.addClass(n.order.none);var i=e.bSortCellsTop;var o=r.closest("thead").find("tr");var l=r.parent().index();r.attr("data-dt-order")==="disable"||r.parent().attr("data-dt-order")==="disable"||i===true&&l!==0||i===false&&l!==o.length-1||t(e.nTable).on("order.dt.DT column-visibility.dt.DT",(function(t,i){if(e===i){var o=i.sortDetails;if(o){var l;var s=n.order;var u=i.api.columns(r);var f=e.aoColumns[u.flatten()[0]];var c=u.orderable().includes(true);var d="";var p=u.indexes();var v=u.orderable(true).flatten();var h=_pluck(o,"col");var g=e.iTabIndex;r.removeClass(s.isAsc+" "+s.isDesc).toggleClass(s.none,!c).toggleClass(s.canAsc,c&&v.includes("asc")).toggleClass(s.canDesc,c&&v.includes("desc"));var m=true;for(l=0;l<p.length;l++)h.includes(p[l])||(m=false);if(m){var _=u.order();r.addClass(_.includes("asc")?s.isAsc:""+_.includes("desc")?s.isDesc:"")}var b=-1;for(l=0;l<h.length;l++)if(e.aoColumns[h[l]].bVisible){b=h[l];break}if(p[0]==b){var y=o[0];var D=f.asSorting;r.attr("aria-sort",y.dir==="asc"?"ascending":"descending");d=D[y.index+1]?"Reverse":"Remove"}else r.removeAttr("aria-sort");if(c){var C=r.find(".dt-column-order");C.attr("role","button").attr("aria-label",c?f.ariaTitle+i.api.i18n("oAria.orderable"+d):f.ariaTitle);g!==-1&&C.attr("tabindex",g)}}}}))}},layout:{_:function(e,r,n){var i=e.oClasses.layout;var o=t("<div/>").attr("id",n.id||null).addClass(n.className||i.row).appendTo(r);DataTable.ext.renderer.layout._forLayoutRow(n,(function(e,r){if(e!=="id"&&e!=="className"){var n="";if(r.table){o.addClass(i.tableRow);n+=i.tableCell+" "}n+=e==="start"?i.start:e==="end"?i.end:i.full;t("<div/>").attr({id:r.id||null,class:r.className?r.className:i.cell+" "+n}).append(r.contents).appendTo(o)}}))},_forLayoutRow:function(e,t){var layoutEnum=function(e){switch(e){case"":return 0;case"start":return 1;case"end":return 2;default:return 3}};Object.keys(e).sort((function(e,t){return layoutEnum(e)-layoutEnum(t)})).forEach((function(r){t(r,e[r])}))}}});DataTable.feature={};DataTable.feature.register=function(e,t,n){DataTable.ext.features[e]=t;n&&r.feature.push({cFeature:n,fnInit:t})};function _divProp(e,t,r){r&&(e[t]=r)}DataTable.feature.register("div",(function(e,r){var n=t("<div>")[0];if(r){_divProp(n,"className",r.className);_divProp(n,"id",r.id);_divProp(n,"innerHTML",r.html);_divProp(n,"textContent",r.text)}return n}));DataTable.feature.register("info",(function(e,r){if(!e.oFeatures.bInfo)return null;var n=e.oLanguage,i=e.sTableId,o=t("<div/>",{class:e.oClasses.info.container});r=t.extend({callback:n.fnInfoCallback,empty:n.sInfoEmpty,postfix:n.sInfoPostFix,search:n.sInfoFiltered,text:n.sInfo},r);e.aoDrawCallback.push((function(e){_fnUpdateInfo(e,r,o)}));if(!e._infoEl){o.attr({"aria-live":"polite",id:i+"_info",role:"status"});t(e.nTable).attr("aria-describedby",i+"_info");e._infoEl=o}return o}),"i");
/**
 * Update the information elements in the display
 *  @param {object} settings dataTables settings object
 *  @memberof DataTable#oApi
 */function _fnUpdateInfo(e,t,r){var n=e._iDisplayStart+1,i=e.fnDisplayEnd(),o=e.fnRecordsTotal(),l=e.fnRecordsDisplay(),s=l?t.text:t.empty;l!==o&&(s+=" "+t.search);s+=t.postfix;s=_fnMacros(e,s);t.callback&&(s=t.callback.call(e.oInstance,e,n,i,o,l,s));r.html(s);_fnCallbackFire(e,null,"info",[e,r[0],s])}var E=0;DataTable.feature.register("search",(function(e,r){if(!e.oFeatures.bFilter)return null;var n=e.oClasses.search;var i=e.sTableId;var o=e.oLanguage;var l=e.oPreviousSearch;var s='<input type="search" class="'+n.input+'"/>';r=t.extend({placeholder:o.sSearchPlaceholder,processing:false,text:o.sSearch},r);r.text.indexOf("_INPUT_")===-1&&(r.text+="_INPUT_");r.text=_fnMacros(e,r.text);var u=r.text.match(/_INPUT_$/);var f=r.text.match(/^_INPUT_/);var c=r.text.replace(/_INPUT_/,"");var d="<label>"+r.text+"</label>";f?d="_INPUT_<label>"+c+"</label>":u&&(d="<label>"+c+"</label>_INPUT_");var p=t("<div>").addClass(n.container).append(d.replace(/_INPUT_/,s));p.find("label").attr("for","dt-search-"+E);p.find("input").attr("id","dt-search-"+E);E++;var searchFn=function(t){var n=this.value;l.return&&t.key!=="Enter"||n!=l.search&&_fnProcessingRun(e,r.processing,(function(){l.search=n;_fnFilterComplete(e,l);e._iDisplayStart=0;_fnDraw(e)}))};var v=e.searchDelay!==null?e.searchDelay:0;var h=t("input",p).val(l.search).attr("placeholder",r.placeholder).on("keyup.DT search.DT input.DT paste.DT cut.DT",v?DataTable.util.debounce(searchFn,v):searchFn).on("mouseup.DT",(function(e){setTimeout((function(){searchFn.call(h[0],e)}),10)})).on("keypress.DT",(function(e){if(e.keyCode==13)return false})).attr("aria-controls",i);t(e.nTable).on("search.dt.DT",(function(t,r){e===r&&h[0]!==document.activeElement&&h.val(typeof l.search!=="function"?l.search:"")}));return p}),"f");DataTable.feature.register("paging",(function(e,r){if(!e.oFeatures.bPaginate)return null;r=t.extend({buttons:DataTable.ext.pager.numbers_length,type:e.sPaginationType,boundaryNumbers:true,firstLast:true,previousNext:true,numbers:true},r);var n=t("<div/>").addClass(e.oClasses.paging.container+(r.type?" paging_"+r.type:"")).append(t("<nav>").attr("aria-label","pagination").addClass(e.oClasses.paging.nav));var draw=function(){_pagingDraw(e,n.children(),r)};e.aoDrawCallback.push(draw);t(e.nTable).on("column-sizing.dt.DT",draw);return n}),"p");function _pagingDynamic(e){var t=[];e.numbers&&t.push("numbers");if(e.previousNext){t.unshift("previous");t.push("next")}if(e.firstLast){t.unshift("first");t.push("last")}return t}function _pagingDraw(e,r,n){if(e._bInitComplete){var i=n.type?DataTable.ext.pager[n.type]:_pagingDynamic,o=e.oLanguage.oAria.paginate||{},l=e._iDisplayStart,s=e._iDisplayLength,u=e.fnRecordsDisplay(),f=s===-1,c=f?0:Math.ceil(l/s),d=f?1:Math.ceil(u/s),p=[],v=[],h=i(n).map((function(e){return e==="numbers"?_pagingNumbers(c,d,n.buttons,n.boundaryNumbers):e}));p=p.concat.apply(p,h);for(var g=0;g<p.length;g++){var m=p[g];var _=_pagingButtonInfo(e,m,c,d);var b=_fnRenderer(e,"pagingButton")(e,m,_.display,_.active,_.disabled);var y=typeof m==="string"?o[m]:o.number?o.number+(m+1):null;t(b.clicker).attr({"aria-controls":e.sTableId,"aria-disabled":_.disabled?"true":null,"aria-current":_.active?"page":null,"aria-label":y,"data-dt-idx":m,tabIndex:_.disabled?-1:e.iTabIndex&&b.clicker[0].nodeName.toLowerCase()!=="span"?e.iTabIndex:null});typeof m!=="number"&&t(b.clicker).addClass(m);_fnBindAction(b.clicker,{action:m},(function(t){t.preventDefault();_fnPageChange(e,t.data.action,true)}));v.push(b.display)}var D=_fnRenderer(e,"pagingContainer")(e,v);var C=r.find(document.activeElement).data("dt-idx");r.empty().append(D);C!==void 0&&r.find("[data-dt-idx="+C+"]").trigger("focus");if(v.length){var S=t(v[0]).outerHeight();n.buttons>1&&S>0&&t(r).height()>=S*2-10&&_pagingDraw(e,r,t.extend({},n,{buttons:n.buttons-2}))}}}
/**
 * Get properties for a button based on the current paging state of the table
 *
 * @param {*} settings DT settings object
 * @param {*} button The button type in question
 * @param {*} page Table's current page
 * @param {*} pages Number of pages
 * @returns Info object
 */function _pagingButtonInfo(e,t,r,n){var i=e.oLanguage.oPaginate;var o={display:"",active:false,disabled:false};switch(t){case"ellipsis":o.display="&#x2026;";break;case"first":o.display=i.sFirst;r===0&&(o.disabled=true);break;case"previous":o.display=i.sPrevious;r===0&&(o.disabled=true);break;case"next":o.display=i.sNext;n!==0&&r!==n-1||(o.disabled=true);break;case"last":o.display=i.sLast;n!==0&&r!==n-1||(o.disabled=true);break;default:if(typeof t==="number"){o.display=e.fnFormatNumber(t+1);r===t&&(o.active=true)}break}return o}
/**
 * Compute what number buttons to show in the paging control
 *
 * @param {*} page Current page
 * @param {*} pages Total number of pages
 * @param {*} buttons Target number of number buttons
 * @param {boolean} addFirstLast Indicate if page 1 and end should be included
 * @returns Buttons to show
 */function _pagingNumbers(e,t,r,n){var i=[],o=Math.floor(r/2),l=n?2:1,s=n?1:0;if(t<=r)i=_range(0,t);else if(r===1)i=[e];else if(r===3)if(e<=1)i=[0,1,"ellipsis"];else if(e>=t-2){i=_range(t-2,t);i.unshift("ellipsis")}else i=["ellipsis",e,"ellipsis"];else if(e<=o){i=_range(0,r-l);i.push("ellipsis");n&&i.push(t-1)}else if(e>=t-1-o){i=_range(t-(r-l),t);i.unshift("ellipsis");n&&i.unshift(0)}else{i=_range(e-o+l,e+o-s);i.push("ellipsis");i.unshift("ellipsis");if(n){i.push(t-1);i.unshift(0)}}return i}var W=0;DataTable.feature.register("pageLength",(function(e,r){var n=e.oFeatures;if(!n.bPaginate||!n.bLengthChange)return null;r=t.extend({menu:e.aLengthMenu,text:e.oLanguage.sLengthMenu},r);var i,o=e.oClasses.length,l=e.sTableId,s=r.menu,u=[],f=[];if(Array.isArray(s[0])){u=s[0];f=s[1]}else for(i=0;i<s.length;i++)if(t.isPlainObject(s[i])){u.push(s[i].value);f.push(s[i].label)}else{u.push(s[i]);f.push(s[i])}var c=r.text.match(/_MENU_$/);var d=r.text.match(/^_MENU_/);var p=r.text.replace(/_MENU_/,"");var v="<label>"+r.text+"</label>";d?v="_MENU_<label>"+p+"</label>":c&&(v="<label>"+p+"</label>_MENU_");var h="tmp-"+ +new Date;var g=t("<div/>").addClass(o.container).append(v.replace("_MENU_",'<span id="'+h+'"></span>'));var m=[];Array.prototype.slice.call(g.find("label")[0].childNodes).forEach((function(e){e.nodeType===Node.TEXT_NODE&&m.push({el:e,text:e.textContent})}));var updateEntries=function(t){m.forEach((function(r){r.el.textContent=_fnMacros(e,r.text,t)}))};var _=t("<select/>",{"aria-controls":l,class:o.select});for(i=0;i<u.length;i++)_[0][i]=new Option(typeof f[i]==="number"?e.fnFormatNumber(f[i]):f[i],u[i]);g.find("label").attr("for","dt-length-"+W);_.attr("id","dt-length-"+W);W++;g.find("#"+h).replaceWith(_);t("select",g).val(e._iDisplayLength).on("change.DT",(function(){_fnLengthChange(e,t(this).val());_fnDraw(e)}));t(e.nTable).on("length.dt.DT",(function(r,n,i){if(e===n){t("select",g).val(i);updateEntries(i)}}));updateEntries(e._iDisplayLength);return g}),"l");t.fn.dataTable=DataTable;DataTable.$=t;t.fn.dataTableSettings=DataTable.settings;t.fn.dataTableExt=DataTable.ext;t.fn.DataTable=function(e){return t(this).dataTable(e).api()};t.each(DataTable,(function(e,r){t.fn.DataTable[e]=r}));export{DataTable as default};

