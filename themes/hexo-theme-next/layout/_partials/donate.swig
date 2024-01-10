{% if theme.donate.enable and page.donate %}
	<!-- css -->
	<style type="text/css">
	    .center {
	        text-align: center;
	    }
	    .hidden {
	        display: none;
	    }
		.donate_bar a.btn_donate{
			display: inline-block;
			width: 82px;
			height: 82px;
			background: url("https://icefire.me/images/btn_reward.gif") no-repeat;
			_background: url("https://icefire.me/images/btn_reward.gif") no-repeat;
			-webkit-transition: background 0s;
			-moz-transition: background 0s;
			-o-transition: background 0s;
			-ms-transition: background 0s;
			transition: background 0s;
			<!-- /让打赏按钮的效果显示正常 而 添加的几行 css 到此结束 -->
		}
		.donate_bar a.btn_donate:hover{ background-position: 0px -82px;}
		.donate_bar .donate_txt {
			display: block;
			color: #9d9d9d;
			font: 14px/2 "Microsoft Yahei";
		}
		.bold{ font-weight: bold; }
	</style>
	<!-- /css -->
    <!-- Donate Module -->
    <div id="donate_module">
	<!-- btn_donate & tips -->
	<div id="donate_board" class="donate_bar center">
		<a id="btn_donate" class="btn_donate" target="_self" href="javascript:;" title="Donate 打赏"></a>
		<span class="donate_txt">
			{{theme.donate.text}}
		</span>
	</div>
	<!-- /btn_donate & tips -->
	<!-- donate guide -->
    
	<div id="donate_guide" class="donate_bar center hidden">
	    {% if theme.donate.web  %}
	    <div width="100%" align="center"><div name="dashmain" id="dash-main-id-87895f" class="dash-main-3 87895f-0.99"></div></div>
		<script type="text/javascript" charset="utf-8" src="https://icefire.me/js/ds.js"></script>
		{% endif %}
		<a href="https://icefire.me/images/wechatPay.jpg" title="用微信扫一扫哦~" class="fancybox" rel="article0">
			<img src="https://icefire.me/images/wechatPay.jpg" title="微信打赏 Donate" height="190px" width="auto"/>
		</a>
        <span class="donate_txt">
			用微信扫一扫哦~
		</span>
        &nbsp;&nbsp;
		<a href="https://icefire.me/images/alipay.jpg" title="用支付宝扫一扫即可~" class="fancybox" rel="article0">
			<img src="https://icefire.me/images/alipay.jpg" title="支付宝打赏 Donate" height="190px" width="auto"/>
		</a>
		<span class="donate_txt">
			用支付宝扫一扫哦~
		</span>
	</div>
	<!-- /donate guide -->
	<!-- donate script -->
	<script type="text/javascript">
		document.getElementById('btn_donate').onclick = function() {
			$('#donate_board').addClass('hidden');
	    $('#donate_guide').removeClass('hidden');
		}
		function donate_on_web(){
			$('#donate').submit();
        }
		var original_window_onload = window.onload;
        window.onload = function () {
            if (original_window_onload) {
                original_window_onload();
            }
            document.getElementById('donate_board_wdg').className = 'hidden';
		}
	</script>
	<!-- /donate script -->
</div>
<!-- /Donate Module -->
{% endif %}