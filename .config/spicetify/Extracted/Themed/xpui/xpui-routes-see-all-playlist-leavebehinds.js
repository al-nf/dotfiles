"use strict";(("undefined"!=typeof self?self:global).webpackChunkclient_web=("undefined"!=typeof self?self:global).webpackChunkclient_web||[]).push([[5040],{96597:(e,t,a)=>{a.d(t,{o:()=>C});var i=a(30758),s=a(6128),n=a(86560),r=a(62856),d=a(93395),l=a(64721),c=a(96930),o=a(65583),u=a(91825),h=a(17934),v=a(61214),_=a(62130),g=a(55285);const b="c5Ml9BbBuUEHjNkcSwZA";var m=a(86070);const f="70px",p=({adId:e,advertiser:t,tagline:a,displayImage:i,buttonMessage:s,cardOnClick:n,buttonOnClick:r,clickthroughUrl:d})=>(0,m.jsx)(g.N,{to:(0,_.H)(d),className:b,"data-testid":"leavebehind",children:(0,m.jsx)(c.v,{onClick:n,onClickHint:l.Ru.get("ad-formats.learnMore"),layout:"wide",variant:"tinted",id:e,size:"xl",title:(0,m.jsx)(o.d,{weight:"bold",variant:"ballad",lineClamp:1,"data-testid":"leavebehind-advertiser",children:t}),subtitle:(0,m.jsx)(u.j,{as:"div",lineClamp:2,"data-testid":"leavebehind-tagline",children:a}),media:(0,m.jsx)(h.C,{"data-testid":"leavebehind-image",src:i.src,alt:i.alt,imageHeight:f,imageWidth:f,size:"xl"}),trailing:(0,m.jsx)(v.$,{onClick:()=>{r&&r()},"data-testid":"leavebehind-button",colorSet:"invertedLight",size:"small","aria-label":l.Ru.get("ad-formats.learnMore"),children:s})})});var k=a(31761),y=a(96009),x=a(57016),I=a(84576);const w="zlUJfROzFEOsEDWL7ucP",E="Fxvq1Fw7XQdGRDvYokRg",C=({leavebehinds:e,seeAllButton:t,surface:a,uri:c})=>{const o=(0,I.vh)(),u=(0,x.w)(x.P),[h,v]=(0,i.useState)(void 0);(0,i.useEffect)((()=>{e&&e.length>0&&h!==e[0].requestId&&c&&(e.forEach(((e,t)=>{e.uri===c&&(e.trackingEvents?.viewed.forEach((async t=>{try{await u(t)}catch(i){const s=i;o.send((0,r.G)({error_type:"trackingURLFailure",error_message:s.message,http_error_code:422,surface:(0,k.Fh)(a),request_url:t,request_type:"leavebehindAds",lineitem_id:e.lineitemId,ad_content_origin:(0,y.Zl)(a)}))}})),o.send((0,d.x)({leavebehind_lineitem_id:e.lineitemId,leavebehind_request_id:e.requestId,event:"event_viewed",event_reason:`viewed_on_${(0,k.Fh)(a).toLowerCase()}`,surface:(0,k.Fh)(a),surface_position:t+1,uri:c})))})),v(e[0].requestId))}),[o,u,e,c,a,h]);const _=({eventReason:e,lineitemId:t,requestId:i,trackingEvents:s,surfacePosition:n})=>{((e,t)=>{t?.forEach((async t=>{try{await u(t)}catch(i){const s=i;o.send((0,r.G)({error_type:"trackingURLFailure",error_message:s.name,http_error_code:422,surface:(0,k.Fh)(a),request_url:t,request_type:"leavebehindAds",lineitem_id:e,ad_content_origin:(0,y.Zl)(a)}))}}))})(t,s),o.send((0,d.x)({leavebehind_lineitem_id:t,leavebehind_request_id:i,event:"event_clicked",event_reason:e,surface:(0,k.Fh)(a),surface_position:n,uri:c}))};return(0,m.jsxs)("section",{"data-testid":"leavebehinds-wrapper",children:[(0,m.jsxs)("div",{className:E,children:[(0,m.jsx)(s.E,{as:"h2",semanticColor:"textBase",variant:"titleSmall",paddingBottom:(0,n.po)("tighter"),"data-testid":"leavebehinds-title",children:l.Ru.get("podcast-ads.recent_ads")}),t]}),(0,m.jsx)("div",{className:w,"data-testid":"leavebehinds-list-wrapper",children:e.map(((e,t)=>(0,m.jsx)(p,{...e,buttonOnClick:()=>{_({eventReason:"button_clicked",lineitemId:e.lineitemId,trackingEvents:e.trackingEvents?.clicked,requestId:e.requestId,surfacePosition:t+1})},cardOnClick:()=>{_({eventReason:"card_clicked",lineitemId:e.lineitemId,trackingEvents:e.trackingEvents?.clicked,requestId:e.requestId,surfacePosition:t+1})}},e.adId)))})]})}},70955:(e,t,a)=>{a.d(t,{SeeAllPlaylistLeavebehinds:()=>o});var i=a(30758),s=a(1978),n=a(96597),r=a(31761),d=a(34221),l=a(96009),c=a(86070);const o=()=>{const e=(0,s.zy)(),{uri:t,playlistName:a}=e.state,o=r.ui.MUSIC_SEE_ALL,{data:u,error:h,getLeavebehinds:v}=(0,d.A)({surface:o,uri:t,playlistName:a});if((0,i.useEffect)((()=>{v()}),[]),!u?.leavebehindAds||h)return null;const _=(0,l.iT)(u,t);return(0,c.jsx)("div",{className:"contentSpacing",children:(0,c.jsx)(n.o,{leavebehinds:_.slice(0,l.E9),surface:o,uri:t})})}},34221:(e,t,a)=>{a.d(t,{A:()=>h});var i=a(30758),s=a(62856),n=a(63166),r=a(59942),d=a(31761),l=a(96009),c=a(84576),o=a(19412),u=a(5050);const h=function(e){const[t,a]=(0,i.useState)(),[h,v]=(0,i.useState)(!1),_=(0,c.vh)(),g=(0,n.NC)(o.SAn,{loadingValue:!1});return{data:t,error:h,getLeavebehinds:(0,i.useCallback)((async()=>{try{const t=await r.b6(u.n.getInstance(),(0,d.Fh)(e.surface),e.uri,e.playlistName,g);a(t.body)}catch(t){const a=t;_.send((0,s.G)({error_type:"fetchAdsFailure",error_message:a.name,http_error_code:a.status,surface:(0,d.Fh)(e.surface),request_type:"leavebehindAds",ad_content_origin:(0,l.Zl)(e.surface)})),v(!0)}}),[_,e.playlistName,e.surface,e.uri,g])}}}}]);
//# sourceMappingURL=xpui-routes-see-all-playlist-leavebehinds.js.map