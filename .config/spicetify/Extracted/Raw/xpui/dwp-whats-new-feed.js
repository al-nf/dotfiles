"use strict";(("undefined"!=typeof self?self:global).webpackChunkclient_web=("undefined"!=typeof self?self:global).webpackChunkclient_web||[]).push([[4084],{30494:(e,t,i)=>{i.d(t,{p:()=>C});var a=i(30758),s=i(97500),n=i.n(s),l=i(6128),r=i(61214),o=i(23893),d=i(2423);const c="(min-width: 0px)",u="(min-width: 0px) and (max-width: 767px)",m="(min-width: 768px)",p="(min-width: 768px) and (max-width: 1023px)",h="(min-width: 1024px)",x="(min-width: 1024px) and (max-width: 1279px)",g="(min-width: 1280px)",y="(min-width: 1280px) and (max-width: 1919px)",w="(min-width: 1920px)",b="FvfvGU3jvHRskUU9v9_8",v="Q9AlbZn2EGzy3MTWXa8X",f="mxmxS0y8LiwSs5nueKPT",j="GXxVAveNFStY3pBI_NO4",k="eHcXC2s97InYP7rMNT0H";var N=i(86070);const C=(0,a.memo)((function(e){const{children:t,message:i,title:a,linkTitle:s,linkTo:C,onClick:E,renderInline:I=!1}=e,{isXSOnly:F,isSMOnly:R}={isXS:(0,d.U)(c),isXSOnly:(0,d.U)(u),isSM:(0,d.U)(m),isSMOnly:(0,d.U)(p),isMD:(0,d.U)(h),isMDOnly:(0,d.U)(x),isLG:(0,d.U)(g),isLGOnly:(0,d.U)(y),isXL:(0,d.U)(w)},S=F||R;return(0,N.jsxs)("section",{className:n()(b,{[v]:I}),children:[t,(0,N.jsx)(l.E,{as:"h1",variant:S?"titleSmall":"titleMedium",className:j,children:a}),(0,N.jsx)(l.E,{variant:S?"bodySmall":"bodyMedium",className:k,children:i}),s&&(C||E)&&(0,N.jsx)(r.$,{colorSet:"invertedLight",className:f,href:C,onClick:E,component:o.v,children:s})]})}))},29425:(e,t,i)=>{i.d(t,{s:()=>x});var a=i(30758),s=i(97500),n=i.n(s),l=i(96613),r=i(75308),o=i(23530),d=i(27054);const c="IVnoxrO3iL_tz5ULI8g_";var u=i(86070);const m={marginBlockEnd:0,willChange:"transform, opacity"},p=({filterId:e=null,isPrimaryFilter:t,isPlaceholder:i,resetFilterIds:s,toggleFilterId:r,className:o,innerRef:d,onFilterClick:p,index:h=0,...x})=>{const g=x.selected,y=(0,a.useCallback)((()=>{if(!e)return s(),void p(null,!1,h);p(e,!!g,h),r(e)}),[e,s,r,p,g,h]),w=(0,a.useCallback)((e=>{e.detail>1||i||y()}),[i,y]);return(0,u.jsx)(l.v,{...x,className:n()(o,{[c]:i}),onClick:w,selectedColorSet:"invertedLight",secondary:g&&!t,style:m,ref:d,tabIndex:-1})},h=({filterId:e=null,isPlaceholder:t,resetFilterIds:i,toggleFilterId:s,className:l,innerRef:o,onFilterClick:d,index:p=0,...h})=>{const x=h.selected,g=(0,a.useCallback)((()=>{if(!e)return i(),void d(null,!1,p);d(e,!!x,p),s(e)}),[e,i,s,d,x,p]),y=(0,a.useCallback)((e=>{e.detail>1||t||g()}),[t,g]);return(0,u.jsx)(r.m,{...h,"aria-label":h["aria-label"],className:n()(l,{[c]:t}),onClick:y,style:m,ref:o,tabIndex:-1})},x=(0,a.memo)((function({placeholderFilters:e=[],availableFilters:t,selectedFilters:i,toggleFilterId:s,resetFilterIds:n,onFilterClick:l,ariaLabel:r,clearBtnAriaLabel:c,className:m,applyLightThemeControls:x=!1}){const g=!(i||t),y=g?e:[...i??[],...t??[]],w=(0,a.useRef)(null),b=(0,a.useCallback)((()=>{(0,d.MS)(w.current,w.current?.nextElementSibling instanceof HTMLElement?w.current?.nextElementSibling:null),n()}),[n]);return 0===y.length?null:(0,u.jsxs)(o.FN,{className:m,ariaLabel:r,applyLightThemeControls:x,children:[!!i?.length&&(0,u.jsx)(h,{resetFilterIds:b,toggleFilterId:s,onFilterClick:l,"aria-label":c??r,innerRef:w}),y.map(((e,t)=>{const a=i?.includes(e),r=0===t;return(0,u.jsx)(p,{filterId:e.id,isPrimaryFilter:r,isPlaceholder:g,onFilterClick:l,resetFilterIds:n,toggleFilterId:s,selected:a,index:t,children:e.getName()},e.id)}))]})}))},45669:(e,t,i)=>{i.d(t,{x:()=>o});var a=i(45129),s=i(43494),n=i(50178);const l="BO7X8b8_SQhDyCjS0EOv";var r=i(86070);const o=({gatedEntityRelations:e,isLocked:t})=>{if(!e)return!1;const i=e?.entitiesWithValueProps?.at(0),o=i?.valueProps.at(0)?.displayText,d=t?i?.summary?.forUserWithoutAccess:i?.summary?.forUserWithAccess;if(!o||!i)return null;const c=(0,r.jsx)(n.E,{icon:t?a.u:void 0,text:o,className:l});return d?(0,r.jsx)(s.Zp,{label:d||o,children:c}):c}},48253:(e,t,i)=>{i.d(t,{P:()=>u});var a=i(63166),s=i(45669),n=i(19412),l=i(71502),r=i(44632),o=i(74511),d=i(30057),c=i(86070);const u=({episode:e})=>{const t=(0,a.NC)(n.MCN,{loadingValue:!1}),{badges:i}=(0,d.b)((e=>"contentRating"in e)(e)?{contentRating:e?.contentRating?.label,isPaywalled:e.podcastSubscription?.isPaywalled}:{isExplicit:e?.isExplicit,isMOGEFRestricted:e?.is19PlusOnly,isPaywalled:e.podcastSubscription?.isPaywalled}),u=e.gatedEntityRelations&&e.gatedEntityRelations.entitiesWithValueProps.at(0),m=!(!u||u.uri===e.uri&&e.podcastSubscription?.isUserSubscribed);return(0,c.jsxs)(c.Fragment,{children:[i.explicit&&(0,c.jsx)(l.U,{}),t&&u?(0,c.jsx)(s.x,{gatedEntityRelations:e.gatedEntityRelations,isLocked:m}):i.paid&&(0,c.jsx)(r.y,{}),i.nineteen&&(0,c.jsx)(o.q,{size:16})]})}},89318:(e,t,i)=>{i.d(t,{P:()=>a.P});var a=i(48253)},55951:(e,t,i)=>{i.d(t,{WhatsNewFeed:()=>He});var a=i(30758),s=i(34889),n=i(97500),l=i.n(n),r=i(6128),o=i(29004),d=i(63166),c=i(81209),u=i(64721),m=i(30494),p=i(84576),h=i(71051),x=i(29425),g=i(11716);const y="q5riNmaoksSuEEvQAurA";var w=i(86070);const b=[{id:"ALBUM",getName:()=>u.Ru.get("web-player.whats-new-feed.filters.music"),ubiId:"Music"},{id:"EPISODE",getName:()=>u.Ru.get("web-player.whats-new-feed.filters.episodes"),ubiId:"Podcast & Shows"},{id:"WHATS_NEW_FEED_NOTIFICATION",getName:()=>u.Ru.get("web-player.whats-new-feed.filters.notifications"),ubiId:"Merch & Events"}],v=(0,a.memo)((function({availableFilters:e,selectedFilters:t,toggleFilterId:i,resetFilterIds:s,className:n,spec:l}){const r=u.Ru.get("web-player.whats-new-feed.filters.options"),o=(0,g.s)(),d=(0,a.useMemo)((()=>{const t=new Map;return(e||[]).forEach((e=>{t.set(e.id,e)})),t}),[e]),c=(0,a.useCallback)(((e,t,i)=>{let a;if(!e)return a=l.clearFiltersFactory().hitClearFilter(),void o.logInteraction(a);const s=d.get(e);if(!s)return;const n=l.filterChipFactory({identifier:s.ubiId,position:i});a=t?n.hitClearFilter():n.hitFilter(),o.logInteraction(a)}),[l,o,d]);return(0,w.jsx)("div",{className:y,children:(0,w.jsx)(x.s,{placeholderFilters:b,availableFilters:e,selectedFilters:t,toggleFilterId:i,onFilterClick:c,resetFilterIds:s,ariaLabel:r,className:n})})}));var f=i(65583),j=i(96930),k=i(91825),N=i(90410),C=i(66810),E=i(60007),I=i(38386),F=i(73145),R=i(44979),S=i(13377),P=i(58681),B=i(13728);const A=({dateAdded:e,prefix:t})=>{let i=e.getTime()>0&&u.Ru.formatRelativeDate(e,{year:"numeric",month:"short",day:"numeric",timeZone:"UTC"});return i&&t&&(i=`${t} ${i}`),(0,w.jsx)(r.E,{variant:"bodySmall",children:i})};var L=i(55285),D=i(2535),M=i(90861);const O=e=>{switch(e){case M.E.LARGE:return D.Qe.SIZE_112;case M.E.MEDIUM:default:return D.Qe.SIZE_64}};var T=i(55530),U=i(92057),_=i(99577),z=i(76597),V=i(41861),G=i(90089),W=i(49066),H=i(73927),Y=i(22727),X=i(56106),q=i(88417),J=i(63112),K=i(24902),Z=i(61546);const Q={xs:"(min-width: 0px)",xsOnly:"(min-width: 0px) and (max-width: 767px)",sm:"(min-width: 768px)",smOnly:"(min-width: 768px) and (max-width: 1023px)",md:"(min-width: 1024px)",mdOnly:"(min-width: 1024px) and (max-width: 1279px)",lg:"(min-width: 1280px)",lgOnly:"(min-width: 1280px) and (max-width: 1919px)",xl:"(min-width: 1920px)",row:"SjhDNg4bQRQmIJAba47Z",actions:"eYvk_xcxVNMwCBkfY3O0",visibleAction:"TtoLzgGMAU9nkxMbixq9",playButton:"Rw7qIj58PeAz8p6dejOP",content:"K3oY37O4n1fElTqkmnd8",description:"AkSMHdbIxX7Fj7e_8APi",subtitleLink:"uzhTSuCH_4ojaqifMJRB",imageWrapper:"q82J4Wio82IYN9poOJfd",imageContainer:"D71yL9GnHIYg7PheYlz8",showImage:"KKRyrr7NUJy1VBWydHHH",largeImage:"kAYwHqwZ7agHEAGbYN3v",explicitIcon:"HjDtVqhmfzWlsvg4dliB",timeAgo:"H4ODi0SPeEXBawCgANeX",footer:"XaingSntLq8c8wEfqf81",episodeBody:"sbM0nIPBghB_k5Tb5a8y",fallbackIcon:"SCFHE5DLXwCFJz8oVFMs",dateAndTime:"FDm94lE0xkDYtA1Bk7Jc",medium:"jYce7J2dSeD3e9qvWO7N",seperator:"tDRI4dCXFmqKzB1b6K3u",seperatorAlbum:"TPNGFuTvzNVNHisumnhg"};function $({album:e,onLike:t,onMoreButtonClick:i,onDownloadClick:s,spec:n}){const o=(0,a.useRef)(null);(0,z.p)(o);const d=(0,G.y)(),c=d===M.E.LARGE,{draggable:m,onDragStart:p}=(0,U.P)({itemUris:[e.uri],dragLabelText:e.name});let h;e.date&&(h=(0,w.jsx)(A,{dateAdded:new Date(e.date.isoString)}));const[x,y]=(0,W.A)(e.uri),b=e.artists?.items.map((e=>e.profile.name)).join(u.Ru.getSeparator())||"",v=(0,g.s)(),D=(0,a.useCallback)((async()=>{try{await y(!x)}catch{}}),[x,y]),{togglePlay:$,isPlaying:ee,isActive:te}=(0,q.P)({uri:e.uri},{featureIdentifier:"whats_new_panel",referrerIdentifier:"whats_new_panel"}),ie=(0,a.useCallback)((t=>{let i;t.preventDefault(),te&&!ee&&(i=n.playButtonFactory().hitResume({itemToBeResumed:e.uri})),ee||te||(i=n.playButtonFactory().hitPlay({itemToBePlayed:e.uri})),ee&&(i=n.playButtonFactory().hitPause({itemToBePaused:e.uri})),i&&v.logInteraction(i),$()}),[$,te,ee,v,n,e.uri]),ae=(0,_.V)(e.uri),se=(0,Y.T)(e.uri),ne=(0,a.useCallback)((()=>{const t=n.hitUiNavigate({destination:e.uri});v.logInteraction(t),ae()}),[e.uri,n,v,ae]),le=(0,a.useCallback)((i=>{const a=n.saveButtonFactory().hitLike({itemToBeLiked:e.uri}),s=n.saveButtonFactory().hitRemoveLike({itemNoLongerLiked:e.uri});v.logInteraction(i?a:s),t?.(i)}),[n,v,e.uri,t]),re=(0,a.useCallback)(((t,i)=>{let a;i===X.NV.ADD?a=n.downloadButtonFactory().hitDownload({itemToDownload:e.uri}):i===X.NV.REMOVE&&(a=n.downloadButtonFactory().hitUiReveal()),a&&v.logInteraction(a),s?.(t,i)}),[e.uri,v,n,s]),oe=(0,a.useCallback)((e=>{i?.(e)}),[i]),de=(0,a.useCallback)((()=>{const t=n.titleFactory().hitUiNavigate({destination:e.uri});v.logInteraction(t)}),[e.uri,v,n]),ce=u.Ru.get("tracklist.a11y.play",e.name,b),ue=u.Ru.get("tracklist.a11y.pause",e.name,b),me=(0,w.jsx)(f.d,{lineClamp:1,children:(0,w.jsx)(L.N,{to:e.uri,onClick:de,children:e.name})}),pe=e.artists?e.artists.items.map(((e,t,i)=>{return(0,w.jsxs)(a.Fragment,{children:[(0,w.jsx)(S.h,{menu:(0,w.jsx)(B.t,{uri:e.uri}),children:(0,w.jsx)(L.N,{to:e.uri,className:Q.subtitleLink,onClick:(s=e.uri,()=>{const e=n.subtitleFactory().hitUiNavigate({destination:s});v.logInteraction(e)}),children:e.profile.name})}),t<i.length-1&&u.Ru.getSeparator()]},t);var s})):"",he=(0,w.jsx)("div",{className:Q.imageContainer,children:(0,w.jsx)(V.b,{className:l()(Q.showImage,{[Q.largeImage]:c}),type:K.c.ALBUM,size:O(d),title:e.name,images:e.coverArt?.sources})}),xe=(0,w.jsxs)(r.E,{className:Q.dateAndTime,children:[(0,Z.C)(e.albumType),(0,w.jsx)("span",{className:Q.seperatorAlbum,children:h})]}),ge=c?C.t.sm:C.t.xs,ye=(0,w.jsxs)("div",{className:Q.footer,children:[(0,w.jsxs)("div",{className:Q.actions,children:[(0,w.jsx)(F.b,{onClick:le,uri:e.uri,size:ge,className:Q.visibleAction}),(0,w.jsx)(E.f,{onClick:re,className:l()({[Q.visibleAction]:(0,H.X)(se)}),uri:e.uri,isFollowing:x,onFollow:D,size:ge,condensed:!0}),(0,w.jsx)(J.r,{spec:n,children:(0,w.jsx)(R.b,{menu:(0,w.jsx)(P.h,{uri:e.uri}),children:(0,w.jsx)(I.e,{onClick:oe,size:ge})})})]}),(0,w.jsx)("div",{className:Q.playButton,children:(0,w.jsx)(T.R,{size:"small",onClick:ie,isPlaying:ee,ariaPlayLabel:ce,ariaPauseLabel:ue,version:T.H.secondary})})]});return(0,w.jsx)(S.h,{menu:(0,w.jsx)(P.h,{uri:e.uri}),children:(0,w.jsx)("div",{draggable:m,onDragStart:p,children:(0,w.jsx)(j.v,{size:"xxl",ref:o,className:Q.row,media:he,title:me,subtitle:(0,w.jsx)(k.j,{lineClamp:1,children:pe}),id:e.uri,variant:"naked",body:xe,footer:ye,onClick:ne,hoverBackgroundColor:"backgroundHighlight",layout:c?"wide":"regular",horizontalGap:c?N.lT:N.CJ,verticalGap:N.v4,paddingBlockStart:"16px",paddingBlockEnd:"16px"})})})}var ee=i(95763),te=i(44503),ie=i(49740),ae=i(9675),se=i(48732),ne=i(1467),le=i(89318),re=i(40564),oe=i(37659);const de={xs:"(min-width: 0px)",xsOnly:"(min-width: 0px) and (max-width: 767px)",sm:"(min-width: 768px)",smOnly:"(min-width: 768px) and (max-width: 1023px)",md:"(min-width: 1024px)",mdOnly:"(min-width: 1024px) and (max-width: 1279px)",lg:"(min-width: 1280px)",lgOnly:"(min-width: 1280px) and (max-width: 1919px)",xl:"(min-width: 1920px)",episodeBody:"N3zMh5FMdbBKUvz4uDfe",progressBar:"h0YQcDKdGmWssZyuIcvq",seperator:"lMQrLkJVNqZAzT95gQnA"},ce=1e4;function ue({episode:e,isPlaying:t,isActive:i,isFullyPlayed:s,setIsFullyPlayed:n}){let l;e.release.date&&(l=(0,w.jsx)(A,{dateAdded:new Date(e.release.date)}));const o=(0,a.useRef)(null),[d]=(0,re.S)(ce,(t=>t?.item?.uri===e.uri));(0,a.useEffect)((()=>{t&&(o.current=d)}),[t,d]),(0,a.useEffect)((()=>{!t&&o.current&&e.duration.milliseconds<=o.current&&n(!0)}),[t,e.duration.milliseconds,n]);const c=(0,a.useRef)(e.duration.milliseconds-e.playedState.timeLeft.milliseconds),m=(0,w.jsx)(oe.j,{isPlaying:t,fullyPlayed:s,durationMs:e.duration.milliseconds,resumePositionMs:o.current||c.current,position:i?d:void 0,className:de.progressBar});return(0,w.jsxs)("div",{className:de.episodeBody,children:[(0,w.jsx)(le.P,{episode:e}),(0,w.jsx)(r.E,{variant:"bodySmall",children:u.Ru.get("card.tag.episode")}),(0,w.jsx)("span",{className:de.seperator}),(0,w.jsx)(r.E,{variant:"bodySmall",children:l}),(0,w.jsx)("span",{className:de.seperator}),(0,w.jsx)(r.E,{variant:"bodySmall",children:m})]})}var me=i(8652);const pe={xs:"(min-width: 0px)",xsOnly:"(min-width: 0px) and (max-width: 767px)",sm:"(min-width: 768px)",smOnly:"(min-width: 768px) and (max-width: 1023px)",md:"(min-width: 1024px)",mdOnly:"(min-width: 1024px) and (max-width: 1279px)",lg:"(min-width: 1280px)",lgOnly:"(min-width: 1280px) and (max-width: 1919px)",xl:"(min-width: 1920px)",row:"IEDOUN3mwwZhHVziC03a",actions:"Olh4d9g46wryDMTzRRmw",visibleAction:"zyDT2CX7tvGjKxxUnO7D",playButton:"TKntS5R19vVI3J9xxwDL",content:"h0EpgyZTOC5U8KOQL4A6",description:"IoTOUob09_0_3kC8ORbu",subtitleLink:"aKVUno8YrkyvGsg7iS59",imageWrapper:"O3nnn9_DD_2DzYEa64jv",imageContainer:"iF91evq0EtvlgCxIRI_6",showImage:"VzSICihKBYcgMsSFv8SH",largeImage:"iOxe1erWkyDFY3p4NG8x",explicitIcon:"iseqhC6eLcxmoGPk6JIE",timeAgo:"kUzqUQECoj43gCthqXdD",footer:"_72TrTBKZHea2vJ2I2BJX",episodeBody:"Bqh5LKZCXF5xkKJcEx7a",fallbackIcon:"OdJvEiRzLWN66tky0bvM",dateAndTime:"Y1f7yukeZPBc6n1uu1pi",medium:"uHM5B97d0hwAYDvOOmY8",seperator:"Oe5t36YEWzbJKH5LBNYD",seperatorAlbum:"dJMAGpC7b6bMSWNEfk6r"};function he({episode:e,podcastName:t,podcastUri:i,onLike:s,onMoreButtonClick:n,onDownloadClick:o,spec:d,featureIdentifier:c,referrerIdentifier:m,size:p="xxl"}){const h=(0,a.useRef)(null);(0,z.p)(h);const x=(0,G.y)(),y=(0,Y.T)(e.uri),b=x===M.E.LARGE,{draggable:v,onDragStart:C}=(0,U.P)({itemUris:[e.uri],dragLabelText:`${e.name} • ${t}`}),E=(0,g.s)(),{togglePlay:I,isPlaying:F,isActive:P}=(0,q.P)({uri:e.uri},{featureIdentifier:c,referrerIdentifier:m}),[B,A]=(0,a.useState)(e.playedState.state===me.M.Completed),D=(0,_.V)(e.uri),W=u.Ru.get("tracklist.a11y.play",e.name,t),Z=u.Ru.get("tracklist.a11y.pause",e.name,t),Q=(0,a.useCallback)((()=>{const t=d.hitUiNavigate({destination:e.uri});E.logInteraction(t),D()}),[D,E,d,e.uri]),$=(0,a.useCallback)((t=>{const i=d.saveButtonFactory().hitLike({itemToBeLiked:e.uri}),a=d.saveButtonFactory().hitRemoveLike({itemNoLongerLiked:e.uri});E.logInteraction(t?i:a),s?.(t)}),[d,E,e.uri,s]),le=(0,a.useCallback)(((t,i)=>{let a;i===X.NV.ADD?a=d.downloadButtonFactory().hitDownload({itemToDownload:e.uri}):i===X.NV.REMOVE&&(a=d.downloadButtonFactory().hitUiReveal()),a&&E.logInteraction(a),o?.(t,i)}),[E,d,e.uri,o]),re=(0,a.useCallback)((()=>{const t=d.titleFactory().hitUiNavigate({destination:e.uri});E.logInteraction(t)}),[E,d,e.uri]),oe=(0,a.useCallback)((t=>{let i;t.preventDefault(),P&&!F&&(i=d.playButtonFactory().hitResume({itemToBeResumed:e.uri})),F||P||(i=d.playButtonFactory().hitPlay({itemToBePlayed:e.uri})),F&&(i=d.playButtonFactory().hitPause({itemToBePaused:e.uri})),i&&E.logInteraction(i),I()}),[I,E,d,e.uri,F,P]),de=(0,a.useCallback)((e=>{n?.(e)}),[n]),ce=(0,w.jsx)(f.d,{lineClamp:2,children:(0,w.jsx)(L.N,{to:e.uri,onClick:re,children:e.name})}),he=(0,w.jsx)(w.Fragment,{children:(0,w.jsx)(k.j,{lineClamp:1,paddingBottom:b?"8px":void 0,children:(0,w.jsx)(S.h,{menu:(0,w.jsx)(ne.H,{uri:i}),children:(0,w.jsx)(L.N,{to:i,className:pe.subtitleLink,onClick:(xe=i,()=>{const e=d.subtitleFactory().hitUiNavigate({destination:xe});E.logInteraction(e)}),children:(0,w.jsx)(r.E,{as:"span",variant:"bodySmall",children:t})})})})});var xe;const ge=(0,w.jsx)("div",{className:pe.imageContainer,children:(0,w.jsx)(V.b,{className:l()(pe.showImage,{[pe.largeImage]:b}),type:K.c.EPISODE,size:O(x),title:e.name,images:e.images})}),ye=b?"medium":"small",we=e.podcastSubscription,be=we.isPaywalled&&!we.isUserSubscribed,ve=!be,fe=(0,w.jsxs)(w.Fragment,{children:[(0,w.jsx)(ue,{episode:e,isPlaying:F,isActive:P,isFullyPlayed:B,setIsFullyPlayed:A}),(0,w.jsxs)("div",{className:pe.footer,children:[(0,w.jsxs)("div",{className:pe.actions,children:[(0,w.jsx)(ae.b,{onClick:$,uri:e.uri,size:ye,className:pe.visibleAction,condensed:!0}),(0,w.jsx)(te.e,{className:l()({[pe.visibleAction]:(0,H.X)(y)}),onClick:le,uri:e.uri,size:ye,canDownload:ve,condensed:!0}),(0,w.jsx)(J.r,{spec:d,children:(0,w.jsx)(R.b,{menu:(0,w.jsx)(se.b,{uri:e.uri,onMarkAsPlayed:A,isPlayed:B}),children:(0,w.jsx)(ie.e,{onClick:de,size:ye})})})]}),(0,w.jsx)("div",{className:pe.playButton,children:(0,w.jsx)(T.R,{"aria-label":"whats-new-feed-play-button",size:"small",onClick:oe,isPlaying:F,ariaPlayLabel:W,ariaPauseLabel:Z,version:T.H.secondary,disabled:!e.isPlayable,locked:be})})]})]}),je=(0,w.jsx)(ee.v,{lineClamp:2,paddingBottom:b?"4px":void 0,className:pe.description,children:(0,w.jsx)(r.E,{as:"span",variant:"bodySmall",children:e.description})});return(0,w.jsx)(S.h,{menu:(0,w.jsx)(se.b,{uri:e.uri,onMarkAsPlayed:A,isPlayed:B}),children:(0,w.jsx)("div",{draggable:v,onDragStart:C,children:(0,w.jsx)(j.v,{size:p,ref:h,className:pe.row,media:ge,title:ce,subtitle:he,id:e.uri,variant:"naked",body:je,footer:fe,onClick:Q,hoverBackgroundColor:"backgroundHighlight",layout:b?"wide":"regular",horizontalGap:b?N.lT:N.CJ,verticalGap:N.v4,paddingBlockStart:"16px",paddingBlockEnd:"16px"})})})}var xe=i(9086),ge=i(19434),ye=i(97542),we=i(58528),be=i(84744);function ve({item:e,spec:t}){if("AlbumResponseWrapper"===e.content.__typename){const i=e.content.data;if("Album"===i.__typename)return(0,w.jsx)($,{album:i,spec:t})}if("EpisodeOrChapterResponseWrapper"===e.content.__typename){const a=e.content.data;if("Chapter"===a.__typename)return(0,w.jsx)(w.Fragment,{});if("Episode"===a.__typename){let e="",s="";return"Podcast"===a.podcastV2.data.__typename&&(e=a.podcastV2.data.name,s=a.podcastV2.data.uri),(0,w.jsx)(he,{episode:(i=a,{type:K.c.EPISODE,uri:i.uri,name:i.name,description:i.description??"",duration:{milliseconds:i.duration.totalMilliseconds},playedState:(0,we.fS)(i.duration,i.playedState),images:i.coverArt?.sources.map(be.m)??[],languages:i.language?[i.language.code]:[],release:{date:i.releaseDate?.isoString,precision:(0,ye.ht)(i.releaseDate)},show:"Podcast"===i.podcastV2.data.__typename?(0,we.jM)(i.podcastV2.data):null,podcastSubscription:(0,we.Wx)(i.restrictions,i.playability),gatedEntityRelations:"gatedEntityRelations"in i?(0,xe.Gv)(i.gatedEntityRelations):void 0,isPlayable:i.playability.playable,isExplicit:i.contentRating?.label===ge.x7.Explicit,is19PlusOnly:i.contentRating?.label===ge.x7.NineteenPlus}),podcastName:e,podcastUri:s,spec:t,referrerIdentifier:"whats_new_panel",featureIdentifier:"whats_new_panel"})}}var i;return(0,w.jsx)(w.Fragment,{})}var fe=i(48472);const je="PNAsPBOgLLv9EX8LZ6xL",ke="UjEEhwY497frsytmeR9u",Ne="VQ0BLAewv7Aw5H3hV0YK",Ce="pxV6pRWzmVb2_leuWtEG",Ee="G97bWDW7Mp3aZEL19Umr",Ie="p6l0_RUXhei0P7rrQaeg",Fe="erd9k4EG_HWK3UzsLhht",Re="ap9brNzQxEcx9SV2FksM",Se="pVVteJIfAdehWU3vX7JR",Pe="J_VZoZ53jBtkdyxrt2My",Be="VOGWdrCvz59_A_wAZv58",Ae="m8V0BPcmce3GusmXkFhM",Le=a.memo((()=>(0,w.jsxs)(w.Fragment,{children:[(0,w.jsx)(fe.Y,{as:"h3",variant:"titleSmall",className:Pe,charCount:4,isLoading:!0}),(0,w.jsx)("div",{className:Re,children:[20,50,25].map(((e,t)=>(0,w.jsx)(fe.Y,{as:"div",variant:"bodySmall",className:Pe,charCount:e,isLoading:!0},`${e}-${t}`)))})]})));var De=i(19412),Me=i(7038),Oe=i(20520),Te=i(50684),Ue=i(1620);const _e={offset:0,limit:50,onlyUnPlayedItems:!1};const ze={[ge.tv.Album]:{id:"ALBUM",getName:()=>u.Ru.get("web-player.whats-new-feed.filters.music"),ubiId:"Music",active:!1},[ge.tv.Episode]:{id:"EPISODE",getName:()=>u.Ru.get("web-player.whats-new-feed.filters.episodes"),ubiId:"Podcast & Shows",active:!1}};function Ve(e){switch(e){case ge.tv.Album:return ge.tv.Album;case ge.tv.Episode:return ge.tv.Episode;case ge.tv.WhatsNewFeedNotification:return ge.tv.WhatsNewFeedNotification;case ge.tv.Unknown:default:return ge.tv.Unknown}}const Ge=({spec:e,items:t})=>{const[i,s]=(0,a.useState)([]),n=e=>{const t=e.state.state;if(!e.state.timestamp?.isoString&&t===ge.GN.New)return!0;if(e.state.timestamp?.isoString){const t=new Date(e.state.timestamp.isoString).getTime();return Date.now()-t<=36e5}return!1},l=t.findIndex((e=>!n(e))),o=(0,a.useCallback)(((t,i)=>{const a=n(t)&&i<l,s=a&&0===i;return(0,w.jsxs)("div",{className:Ae,children:[s&&(0,w.jsx)(r.E,{as:"h3",variant:"titleSmall",className:Ne,semanticColor:"textBase",children:u.Ru.get("web-player.whats-new-feed.new-section-title")}),!a&&i===l&&(0,w.jsx)(r.E,{as:"h3",variant:"titleSmall",className:Ne,semanticColor:"textBase",children:u.Ru.get("web-player.whats-new-feed.earlier-section-title")}),(0,w.jsx)("hr",{className:Be,"aria-hidden":!0}),(0,w.jsx)(ve,{item:t,spec:e.notificationItemFactory({identifier:t.id,position:i})},t.id)]},t.id)}),[l,e]),d=(0,a.useRef)(0),c=(0,a.useCallback)((()=>{const e=t.slice(d.current,d.current+10);s((t=>(d.current=d.current+10,[...t,...e])))}),[t]),{ref:m,breakpoint:p}=(0,Oe.x)({[M.E.MEDIUM]:0,[M.E.LARGE]:600});return(0,w.jsx)(G.o.Provider,{value:p,children:(0,w.jsx)("div",{className:Fe,role:"list",ref:m,children:(0,w.jsx)(Me._,{onReachBottom:c,triggerOnInitialLoad:!0,children:i.map(o)})})})},We=({includedContentTypes:e,data:t,handleRetry:i,error:a,spec:s,loading:n})=>{if(n)return(0,w.jsxs)("div",{className:Ce,role:"list",children:[(0,w.jsx)(Le,{}),(0,w.jsx)(Le,{})]});if(a)return(0,w.jsxs)("div",{className:Ee,dir:"auto",children:[(0,w.jsx)(r.E,{as:"h2",variant:"titleSmall",semanticColor:"textBase",children:u.Ru.get("error.generic")}),(0,w.jsx)(r.E,{as:"p",variant:"bodyMedium",children:u.Ru.get("web-player.whats-new-feed.panel.error")}),(0,w.jsx)(o.n,{className:Ie,onClick:i,size:"small",children:(0,w.jsx)(r.E,{as:"span",variant:"bodyMediumBold",semanticColor:"textBase",children:u.Ru.get("web-player.whats-new-feed.panel.error.button")})})]});const l=t?.whatsNewFeedItems?.items;if(!l||0===l?.length){const{title:t,message:i}=function(e=[]){return e.includes(ge.tv.Episode)?{title:u.Ru.get("web-player.whats-new-feed.panel.empty-results-podcast.title"),message:u.Ru.get("web-player.whats-new-feed.panel.empty-results-podcast.message")}:e.includes(ge.tv.Album)?{title:u.Ru.get("web-player.whats-new-feed.panel.empty-results-music.title"),message:u.Ru.get("web-player.whats-new-feed.panel.empty-results-music.message")}:{title:u.Ru.get("web-player.whats-new-feed.panel.empty-results-all.title"),message:u.Ru.get("web-player.whats-new-feed.panel.empty-results-all.message")}}(e);return(0,w.jsx)(m.p,{title:t,message:i,renderInline:!0})}return(0,w.jsx)(Ge,{items:l,spec:s},e.join(" "))},He=()=>{const e=(0,s.jE)(),{spec:t,logger:i}=(0,Ue.r)(c.q,{}),n=(0,a.useCallback)((()=>{const{name:e}=h.lo;return[e]}),[]),o=(0,a.useCallback)((()=>{e.invalidateQueries({queryKey:n()})}),[e,n]);(0,a.useEffect)((()=>{i.logImpression(t.impression())}),[i,t]);const[m,x]=(0,a.useState)(ze),g=Object.values(m),y=g.filter((e=>e.active)),b=y.length>0?[]:g,f=y.map((e=>e.id)),j=(0,d.NC)(De.MCN,{loadingValue:!1}),k=(0,a.useCallback)((e=>{const t=Ve(e),i={id:m[t]?.id||ge.tv.Unknown,getName:()=>m[t]?.getName()||"",ubiId:m[t]?.ubiId||"",active:!m[t]?.active},a={...ze,...m,[i.id||"UNKNOWN"]:i};x(a)}),[m,x]),N=(0,a.useCallback)((()=>{x(ze)}),[x]),{data:C,error:E,loading:I}=(0,Te.I)(j?h.nD:h.lo,{..._e,includedContentTypes:f.map(Ve)??[]},{gcTime:30*Te.i}),{getGraphQLLoader:F}=(0,p.mv)(),R=F();return(0,a.useEffect)((()=>{if(!C?.whatsNewFeedItems?.items)return;const e=C?.whatsNewFeedItems?.items.filter((e=>e.state.state===ge.GN.New)).map((e=>({id:e.id,state:ge.GN.Seen})));e.length>0&&async function(e,t){await e(h.BP,{items:t})}(R,{items:e})}),[C?.whatsNewFeedItems?.items,R]),(0,w.jsxs)("section",{className:l()(Se,"contentSpacing"),children:[(0,w.jsxs)("div",{className:je,children:[(0,w.jsx)(r.E,{as:"h1",semanticColor:"textBase",variant:"titleMedium",className:ke,children:u.Ru.get("web-player.whats-new-feed.panel.title")}),(0,w.jsx)(r.E,{as:"p",semanticColor:"textSubdued",variant:"bodySmall",children:u.Ru.get("web-player.whats-new-feed.panel.subtitle")})]}),!E&&(0,w.jsx)(v,{availableFilters:b,toggleFilterId:k,selectedFilters:y,resetFilterIds:N,spec:t.filterChipsFactory()}),(0,w.jsx)(We,{includedContentTypes:f.map(Ve),data:C,loading:I,error:E??null,spec:t,handleRetry:o})]})}},44632:(e,t,i)=>{i.d(t,{y:()=>l});var a=i(64721),s=i(50178),n=i(86070);const l=()=>(0,n.jsx)(s.E,{ariaLabel:a.Ru.get("paid"),text:a.Ru.get("paid")})},7038:(e,t,i)=>{i.d(t,{_:()=>c});var a=i(30758),s=i(21743),n=i(97500),l=i.n(n);const r="eqw9lvuoZHrkWMTdyTpY",o="lb08f71wES9AQnKx6e0R";var d=i(86070);const c=(0,a.memo)((function(e){const{triggerOnInitialLoad:t=!1,onReachBottom:i,showScrollbar:n=!0,horizontalScroll:c=!1,className:u}=e,{ref:m,inView:p}=(0,s.Wx)({initialInView:t});return(0,a.useLayoutEffect)((()=>{p&&i&&i()}),[p,i]),(0,d.jsxs)("div",{className:l()({[o]:!n,[r]:c},u),"data-testid":"infinite-scroll-list",children:[e.children,(0,d.jsx)("div",{ref:m})]})}))},76597:(e,t,i)=>{i.d(t,{p:()=>s});var a=i(30758);const s=e=>{const[t,i]=(0,a.useState)(0);function s(a){const s=e.current?.querySelectorAll('button:not([disabled]), [href], input, select, textarea, a,[tabindex]:not([tabindex="-1"])');if(!s)return;s.forEach((e=>{e.setAttribute("tabindex","-1")})),s&&s[0].setAttribute("tabindex","0");let n=t;if(s&&s.length>0)switch(a.key){case"Tab":document.activeElement&&i(0);break;case"ArrowUp":0===n?(a.preventDefault(),n=s.length-1):n-=1,s[n].focus(),i(n);break;case"ArrowDown":a.preventDefault(),n===s.length-1?n=0:n+=1,s[n].focus(),i(n)}}a.useEffect((()=>{const t=e.current;return t?.addEventListener("keydown",s),()=>{t?.removeEventListener("keydown",s)}}))}},73927:(e,t,i)=>{i.d(t,{X:()=>s});var a=i(56106);function s(e){return[a.kw.YES,a.kw.DOWNLOADING,a.kw.WAITING].includes(e)}}}]);
//# sourceMappingURL=dwp-whats-new-feed.js.map