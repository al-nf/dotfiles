"use strict";(("undefined"!=typeof self?self:global).webpackChunkclient_web=("undefined"!=typeof self?self:global).webpackChunkclient_web||[]).push([[5260],{83842:(e,t,n)=>{n.d(t,{A:()=>u});var a=n(30758),s=n(97500),i=n.n(s),r=n(75627),o=n(46101),l=n(86070);const c="div";class d extends a.Component{constructor(e){super(e),this.state={isDropTargetActive:!1},this.enterEventCount=0,this.leaveEventCount=0}componentDidMount(){document.body.addEventListener("dragend",this.handleDragEnd)}shouldComponentUpdate(e,t){return t.isDropTargetActive!==this.state.isDropTargetActive||e.children!==this.props.children||e.onDragEnter!==this.props.onDragEnter||e.onDragLeave!==this.props.onDragLeave||e.onDrop!==this.props.onDrop||e.types.length!==this.props.types.length||e.types.some(((e,t)=>e!==this.props.types[t]))}componentWillUnmount(){document.body.removeEventListener("dragend",this.handleDragEnd)}handleDragOver=e=>{this.getMatchingMimeTypes(e).length>0&&(e.preventDefault(),e.dataTransfer.dropEffect="copy")};handleDragEnter=e=>{this.enterEventCount&&!e.relatedTarget||(this.enterEventCount++,1===this.enterEventCount&&this.getMatchingMimeTypes(e).length>0&&(this.props.onDragEnter?.(e),this.setState({isDropTargetActive:!0})))};handleDragLeave=e=>{this.leaveEventCount++,this.leaveEventCount===this.enterEventCount&&this.getMatchingMimeTypes(e).length>0&&(this.enterEventCount=0,this.leaveEventCount=0,this.props.onDragLeave?.(e),this.setState({isDropTargetActive:!1}))};handleDragEnd=()=>{this.enterEventCount=0,this.leaveEventCount=0};handleDrop=e=>{if(0===this.getMatchingMimeTypes(e).length)return;const{onDragLeave:t,onDrop:n}=this.props,a=this.getMatchingDropData(e);this.enterEventCount=0,this.leaveEventCount=0;const s=e.defaultPrevented;e.preventDefault(),t?.(e),s||n(e,a),this.setState({isDropTargetActive:!1})};getMatchingMimeTypes(e){const t=this.props.types;return Array.from(e.dataTransfer.types).filter((e=>t.includes(e)))}getMatchingDropData(e){const t=this.getMatchingMimeTypes(e),n={};t.forEach((t=>{const a=e.dataTransfer.getData(t),s=0===t.indexOf("text/x-spotify"),i=s?a.split("\n"):[a];n[t]=i.map((e=>{if(s){const t=(0,r.o_h)(e);if(t)return t.toURI()}return e})).filter((e=>!!e))}));const a=e.dataTransfer.getData("text/plain");return n.all=a?a.split("\n").map((e=>{const t=(0,r.o_h)(e);return t?t.toURI():e})):[],n}render(){const{types:e=[],as:t=c,testId:n,className:a=""}=this.props,s=t,r=e.filter(Boolean).map((e=>`GlueDropTarget--${e.replace("text/x-spotify-","")}`));return(0,l.jsx)(s,{className:i()("GlueDropTarget",r,{"GlueDropTarget--active":this.state.isDropTargetActive},a),onDragOver:this.handleDragOver,onDragEnter:this.handleDragEnter,onDragLeave:this.handleDragLeave,onDrop:this.handleDrop,onContextMenu:this.props.onContextMenu,"data-testid":n,children:this.props.children})}}const u=e=>{const{supportsDragAndDrop:t}=(0,o._)();if(!t){const t=e.as??c;return(0,l.jsx)(t,{children:e.children})}return(0,l.jsx)(d,{...e})}},20057:(e,t,n)=>{n.d(t,{s:()=>i});var a=n(6128),s=n(86070);const i=({variant:e})=>(0,s.jsx)(a.E,{variant:e,semanticColor:"textBase",children:"Spotify"})},60528:(e,t,n)=>{n.d(t,{R:()=>u});var a=n(30758),s=n(95440),i=n(75627),r=n(14576),o=n(83842),l=n(92057),c=n(89494),d=n(86070);const u=({uri:e,owner:t,children:n})=>{const u=(0,s.wA)(),m=(0,c.W)(),p=(0,s.d4)((e=>e.session.user?.id)),h=(0,i.tbX)(e),g=(0,a.useCallback)(((t,n)=>{const a=[...n[l.O[i.NQG.ALBUM]]||[],...n[l.O[i.NQG.TRACK]]||[],...n[l.O[i.NQG.LOCAL_TRACK]]||[],...n[l.O[i.NQG.EPISODE]]||[]];a.length>0&&(u((0,r.io)(e,a)),m({targetUri:e,intent:"add",type:"drop"}))}),[u,m,e]);return h&&t===p?(0,d.jsx)(o.A,{types:[l.O[i.NQG.ALBUM],l.O[i.NQG.TRACK],l.O[i.NQG.EPISODE],l.O[i.NQG.LOCAL]],onDrop:g,testId:"cover-drop-target",children:n}):(0,d.jsx)(d.Fragment,{children:n})}},64842:(e,t,n)=>{n.d(t,{a:()=>h});var a=n(30758),s=n(97500),i=n.n(s),r=n(64721),o=n(53232),l=n(14654),c=n(72744),d=n(93915),u=n(18032),m=n(4114),p=n(86070);const h=({context:e,item:t,className:n,onClick:s=(()=>{})})=>{const{dislikeEndpoint:h,shouldShowFeedbackControls:g}=(0,l.d)(e),{enqueueSnackbar:v}=(0,c.d)(),x=e.metadata?.[u.W.CONTEXT_DESCRIPTION]??"",{setDislikeFeedback:f}=(0,d.I)({uri:t.uri,setFeedbackPath:h,contextUri:e.uri}),y=(0,a.useCallback)((async()=>{f(),v(r.Ru.get("feedback.hide-song",x)),s?.()}),[f,v,x,s]);return(0,m.v)(t)&&g?(0,p.jsx)(o.O,{className:i()(n,{"control-button":!n,"control-button-feedback":!n}),isDisliked:!1,onClick:y}):null}},90:(e,t,n)=>{n.d(t,{g:()=>h});var a=n(30758),s=n(97500),i=n.n(s),r=n(6128),o=n(64721),l=n(57682);const c="w0kwPDoelauN3C9dVoVe",d="xzLZD9uD3b4u9wecXAJY",u="DaFhhSm73r7rNpomErhI";var m=n(86070);const p=({children:e})=>(0,m.jsx)(m.Fragment,{children:e}),h=(0,a.forwardRef)((function({users:e,maxSlots:t=3,size:n,withoutOverflowBadge:a=!1,dropShadow:s=!1,AvatarWrapper:h=p},g){const v=Math.max(2,t),x=e.length>v?e.length-v+1:0,f=e.slice(0,v),{userIconSize:y,width:b,smallFontSize:D,largeFontSize:C}=(e=>{switch(e){case"xxlarge":return{userIconSize:"xlarge",width:64,smallFontSize:24,largeFontSize:32};case"xlarge":return{userIconSize:"large",width:48,smallFontSize:18,largeFontSize:24};case"large":return{userIconSize:"medium",width:32,smallFontSize:12,largeFontSize:16};case"medium":default:return{userIconSize:"small",width:24,smallFontSize:9,largeFontSize:12};case"small":return{userIconSize:"xsmall",width:18,smallFontSize:8,largeFontSize:10}}})(n),E=x>9?D:C,S=(0,m.jsx)("span",{className:i()(d,"encore-inverted-light-set"),style:{width:b,height:b},role:"presentation",children:(0,m.jsx)(r.E,{variant:"bodySmallBold",style:{fontSize:E},semanticColor:"textBase",children:`+${x}`})});return(0,m.jsx)("div",{className:i()(c),ref:g,children:f.map(((e,t)=>!a&&x>0&&t===v-1?(0,m.jsx)(h,{index:t,children:(0,m.jsx)(l.e,{images:[],userIconSize:y,label:o.Ru.get("web-player.social-connect.facepile.and-others",x),width:b,piled:!0,customPlaceholder:S})},"others"):(0,m.jsx)(h,{index:t,user:e,children:(0,m.jsx)(l.e,{images:e.images,userIconSize:y,label:e.displayName,displayName:e.displayName,username:e.username,width:b,piled:t>0,imageClassName:s?u:void 0})},e.displayName)))})}))},58704:(e,t,n)=>{n.d(t,{g:()=>c});var a=n(30758),s=n(17256),i=n(70223),r=n(18775),o=n(21699),l=n(77368);function c(){const e=(0,r.V)(),t=(0,l.u)(),[n,c]=(0,a.useState)(null),d=(0,a.useCallback)((async()=>{const n=e.getDefaultDevice();if(null===n)return void c(null);if(n.transportType!==s.Yg.BLUETOOTH)return void c({audioDevice:n});const a=await t.lookup(n.name);c({audioDevice:n,externalAccessory:a})}),[e,t]);return(0,o.k)(i.B.DEVICE_CONNECTED,d),(0,a.useEffect)((()=>{d()}),[d]),n}},80488:(e,t,n)=>{n.d(t,{l:()=>c});var a=n(63166),s=n(88318),i=n(38254),r=n(64407),o=n(27602);const l={id:"",connectStateId:"",name:"",type:r.bq.COMPUTER,isGroup:!1,isLocal:!0,isActive:!0,isConnecting:!1,isDisabled:!1,volume:0,losslessSupport:{fullySupported:!1,deviceSupported:!1,userEligible:!1},supportsLogout:!1,supportedMediaTypes:null},c=()=>{const e=(0,a.NC)(o.vF),t=(0,s.Z)(),{activeDevice:n,devices:r}=(0,i.v)((n=>({activeDevice:e?t.getActiveDevice():n.activeDevice,devices:e?t.getDevices():n.devices})));return{currentDevice:n??l,devices:r}}},13556:(e,t,n)=>{n.d(t,{r:()=>h});var a=n(30758),s=n(95440),i=n(40894),r=n(15628),o=n(37145),l=n(86502),c=n(13979),d=n(2799),u=n(69069),m=n(28261),p=n(77136);function h(){const e=(0,s.d4)(o.u),t=(0,s.wA)(),{setYlxSidebarState:n}=(0,u.$)(),{mainLandmarkRef:h,lyricsCinemaRef:g}=(0,i.JT)(),{isActive:v,panelSend:x}=(0,l.AI)(d.Z.NowPlayingView);return{mode:e,setMode:(0,a.useCallback)((e=>{e===m.YU.cinema&&v?(g.current?.classList.add(p.A.lyricsCinemaVisible),h.current?.classList.add(p.A.nonDisplayedArea),n(u.fX.COLLAPSED),x(c.$S.NPV_BUTTON_CLICK)):(g.current?.classList.remove(p.A.lyricsCinemaVisible),h.current?.classList.remove(p.A.nonDisplayedArea),v||x(c.$S.NPV_BUTTON_CLICK)),t((0,r.gh)(e))}),[t,x,v,g,h,n])}}},58901:(e,t,n)=>{n.d(t,{P:()=>u,X:()=>d});var a=n(64721),s=n(45640),i=n(45080),r=n(61804),o=n(4114),l=n(91950),c=n(85690);function d(e){return(0,o.v)(e)?a.Ru.get("playback-control.now-playing-label",e.name,e.artists.map((({name:e})=>e)).join(a.Ru.getSeparator())):(0,r.p)(e)?a.Ru.get("playback-control.now-playing-label",e.name,e.show.name):(0,i.d)(e)?a.Ru.get("playback-control.now-playing-label",e.name,e.book.name):(0,s.N)(e)?a.Ru.get("ad-formats.advertisement"):(0,l.v)(e)?void 0:(0,c.d)(e)}function u(e){let t=d(e);return t||(t=a.Ru.get("queue.now-playing")),t}},14654:(e,t,n)=>{n.d(t,{d:()=>a});const a=e=>{const t=e?.metadata?.["dislike-endpoint"]??null;return{dislikeEndpoint:t,shouldShowFeedbackControls:"1"===e?.metadata?.["dislike-feedback-available"]&&null!==t}}},39470:(e,t,n)=>{n.d(t,{e:()=>g});var a=n(30758),s=n(55285),i=n(81362),r=n(58901),o=n(45640),l=n(45080),c=n(61804),d=n(4114),u=n(91950),m=n(85690),p=n(86070);const h=(0,a.lazy)((()=>n.e(2073).then(n.bind(n,72073)))),g=({context:e,index:t,item:n,isVisible:g,children:v,className:x,referrer:f,onClick:y,adEventReason:b})=>{const D=(0,r.P)(n),C=n.type,E=g?void 0:-1;if((0,d.v)(n)||(0,c.p)(n)||(0,l.d)(n)){const a=(0,i.O)(e,n,t);return a?(0,p.jsx)(s.N,{className:x,referrer:f,"data-testid":"context-link","data-context-item-type":C,style:{border:"none"},to:a.to,search:a.search,"aria-label":D,tabIndex:E,onClick:y,children:v}):(0,p.jsx)(p.Fragment,{children:v})}return(0,o.N)(n)?(0,p.jsx)(a.Suspense,{fallback:(0,p.jsx)(p.Fragment,{children:v}),children:(0,p.jsx)(h,{item:n,"aria-label":D,tabIndex:E,adEventReason:b,children:v})}):(0,u.v)(n)?(0,p.jsx)(p.Fragment,{children:v}):(0,m.d)(n)}},41968:(e,t,n)=>{n.d(t,{j:()=>m});var a=n(30758),s=n(34889),i=n(15758),r=n(17256),o=n(73868),l=n(68656),c=n(27118),d=n(50852);const u={headphoneDevice:null,audioDevice:null,predictedState:null,isOnboarded:!1,currentState:{externalizationEnabled:!1,specificEnabled:!1},contentRestrictions:{specificRestricted:!1,externalizationRestricted:!1,processingCapabilitiesRestricted:!1},toggleTuneHeadphones:null,toggleTuneStudio:null,setFilterState:()=>Promise.resolve()},m=()=>{const e=(0,l.N)(),t=(0,s.jE)(),n=(0,o.l)(),m=(0,a.useMemo)((()=>["puffin-current-device"]),[]),{data:p,isLoading:h,isError:g}=(0,i.I)({queryKey:m,queryFn:async()=>await e.getFilterState(),gcTime:5e3,staleTime:5e3});var v;return v=()=>{t.invalidateQueries({queryKey:m})},(0,d.G)(c.n.UPDATE,v),{deviceFilterState:!n&&p||u,isMaybeHeadphoneDevice:(0,r.lS)(p?.audioDevice),isLoading:h,isError:g}}},63912:(e,t,n)=>{n.d(t,{o:()=>r});var a=n(30758),s=n(41968),i=n(76698);const r=()=>{const{deviceFilterState:e}=(0,s.j)(),t=(0,a.useMemo)((()=>e.audioDevice?.id),[e.audioDevice?.id]),[n,r]=(0,i.x)("onboarding-dismissed:puffin",{}),o=(0,a.useCallback)((()=>{t&&r({...n,[t]:(n[t]??0)+1})}),[t,n,r]);return{isDeviceDismissed:(0,a.useMemo)((()=>!!t&&n[t]>=3),[t,n]),incrementDismissCountForDevice:o}}},37375:(e,t,n)=>{n.d(t,{o:()=>w});var a=n(30758),s=n(97500),i=n.n(s),r=n(40748),o=n(36196),l=n(16348),c=n(96296),d=n(75627),u=n(64721),m=n(43494),p=n(59911),h=n(90861),g=n(90089),v=n(21111),x=n(45210),f=n(11716),y=n(1620);const b="VcqCvLW71lZT4kqnCgt0";var D=n(86070);const C=({contextUri:e="",uri:t,id:n=t,className:s,canAdd:d})=>{const{description:x}=(0,v.f)(),C=(0,f.s)(),{spec:E}=(0,y.r)(c.A,{data:{uri:e}}),S=(0,a.useCallback)((()=>{C.logInteraction(E.undoButtonFactory({uri:t}).hitUiHide())}),[C,E,t]),w=(0,a.useCallback)((()=>{C.logInteraction(E.removeRecommendationButtonFactory({uri:t}).hitRemoveRecommendation({recommendedItemUri:t,contextUri:e}))}),[e,C,E,t]),A=(0,a.useCallback)((()=>{C.logInteraction(E.addRecommendationButtonFactory({uri:t}).hitAddToPlaylist({playlist:e,itemToBeAdded:t}))}),[e,C,E,t]),{removeRecommendation:N,addRecommendation:k,canRemoveRecommendation:R,canAddRecommendation:T}=(0,p.t)({uri:t,uid:n,contextUri:e,onUndo:S,onRemoveRecommendation:w,onAddRecommendation:A}),F=(0,a.useCallback)((()=>x?u.Ru.get("web-player.smart-shuffle.add-to-playlist-button",x):u.Ru.get("web-player.smart-shuffle.add-to-playlist-button-fallback")),[x]),I=(0,g.y)();return(0,D.jsxs)("div",{className:i()(b,s),children:[R&&(0,D.jsx)(m.Zp,{label:u.Ru.get("web-player.smart-shuffle.removed-from-recommendations-button"),children:(0,D.jsx)(r.H,{onClick:N,iconOnly:o.P,size:I===h.E.MEDIUM?"medium":"small","aria-label":u.Ru.get("web-player.smart-shuffle.removed-from-recommendations-button"),condensedAll:!0})}),d&&T&&(0,D.jsx)(m.Zp,{label:F(),children:(0,D.jsx)(r.H,{onClick:k,iconOnly:l.P,size:I===h.E.MEDIUM?"medium":"small","aria-label":F(),condensedAll:!0})})]})},E=e=>{const t=(0,x.J)(e.contextUri);return(0,D.jsx)(C,{...e,canAdd:t?.canAdd??!1})},S=e=>(0,D.jsx)(C,{...e,canAdd:!0}),w=e=>e.contextUri&&(0,d.tbX)(e.contextUri)?(0,D.jsx)(E,{...e,contextUri:e.contextUri}):e.contextUri&&(0,d.Z0m)(e.contextUri)?(0,D.jsx)(S,{...e,contextUri:e.contextUri}):(0,D.jsx)(C,{...e,canAdd:!1})},12344:(e,t,n)=>{n.d(t,{c:()=>i,t:()=>r});var a=n(75627);const s=e=>({url:e}),i=e=>{const t=[];return e.largeImageUrl?t.push(s(e.largeImageUrl)):e.imageUrl&&t.push(s(e.imageUrl)),{displayName:e.displayName,images:t,username:e.username,uri:(0,a.Qjr)(e.username).toURI()}},r=(e,t,n)=>{const a=[],s=e.sessionMembers.find((({id:t})=>t===e.sessionOwnerId));s&&a.push(s);const r=e.isSessionOwner?void 0:e?.sessionMembers.find((({username:e})=>e===t));r&&(n?.userFirst?a.unshift(r):a.push(r));const o=e.sessionMembers.filter((({username:n,id:a})=>a!==e.sessionOwnerId&&n!==t));return[...a,...o].map(i)}},83211:(e,t,n)=>{n.d(t,{K:()=>f});var a=n(30758),s=n(95440),i=n(7004),r=n(6128),o=n(64721),l=n(13625),c=n(90),d=n(12344),u=n(26442),m=n(75627),p=n(1620);var h=n(4316);const g="UWuPbrFbZar0lIcBFH31",v="wFkvSGFYuw6rhfwWWYWC";var x=n(86070);const f=()=>{const{currentSession:e}=(0,h.D)(),t=(0,s.d4)((({session:e})=>e.user?.id)),{logJamNameClick:n}=(()=>{const{spec:e,logger:t}=(0,p.r)(u.V,{});return{logJamNameClick:(0,a.useCallback)((()=>{const n=e.jamNameFactory().hitUiNavigate({destination:(0,m.K72)().toURI()});t.logInteraction(n)}),[t,e])}})(),{openQueue:f}=(0,l.R)(),y=(0,a.useCallback)((()=>{n(),f()}),[n,f]);if(!e?.active)return null;const b=e.sessionMembers.find((({id:t})=>t===e.sessionOwnerId)),D=(0,d.t)(e,t,{userFirst:!0});return(0,x.jsxs)("div",{className:g,children:[(0,x.jsx)(c.g,{users:D,dropShadow:!0,size:"small"}),(0,x.jsx)(i.Y,{className:v,onClick:y,semanticColor:"textBase",tabIndex:0,standalone:!0,children:(0,x.jsx)(r.E,{variant:"bodySmallBold",children:o.Ru.get("web-player.social-connect.session-info.title",{host:b?.displayName??""})})})]})}},82199:(e,t,n)=>{n.d(t,{v:()=>i});var a=n(68656),s=n(2607);const i=()=>{const e=(0,a.N)(),t="1"===(0,s.$)("is-puffin");return e.isAvailable()&&t}},50852:(e,t,n)=>{n.d(t,{G:()=>i});var a=n(30758),s=n(68656);function i(e,t){const n=(0,a.useRef)(t),i=(0,s.N)();n.current=t,(0,a.useEffect)((()=>{const t=i.getFiltersEvents();return t?.addListener(e,(e=>{n.current(e)}))}),[e,i])}},7917:(e,t,n)=>{n.d(t,{c:()=>o});var a=n(30758),s=n(69191),i=n(76766),r=n(14903);function o(e,t){const n=(0,i.d)(),o=(0,r.A)(t),l=(0,s.a)();(0,a.useEffect)((()=>n.getBroadcastingEvents().addListener(e,(e=>{l()&&o(e)}))),[n,o,e,l])}},77136:(e,t,n)=>{n.d(t,{A:()=>a});const a={xs:"(min-width: 0px)",xsOnly:"(min-width: 0px) and (max-width: 767px)",sm:"(min-width: 768px)",smOnly:"(min-width: 768px) and (max-width: 1023px)",md:"(min-width: 1024px)",mdOnly:"(min-width: 1024px) and (max-width: 1279px)",lg:"(min-width: 1280px)",lgOnly:"(min-width: 1280px) and (max-width: 1919px)",xl:"(min-width: 1920px)",lyricsCinemaVisible:"sgQuNaOh5Eu6vnzh3eoh",nonDisplayedArea:"KJNUWtMTBWtQrmsas64b",Container:"F3qS5Fne4ECzEWyFeJ5S",Controls:"dS_1_x4lBrx_vX9AMg6Q",Content:"mC8gFZzy9ZRO5c61MeuO"}}}]);
//# sourceMappingURL=5260.js.map