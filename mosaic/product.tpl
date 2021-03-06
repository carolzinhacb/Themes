{#
Description: Product Page
#}

{% macro wishlist_block(product, user) %}
	{% if user.is_logged_in %}
		<div class="wishlist">
			{% if not product.wishlist.status %}
				<a href="{{ product.wishlist.add_url }}"><i class="fa fa-heart fa-fw fa-lg"></i></a>
			{% else %}
				<a href="{{ product.wishlist.remove_url }}"><i class="fa fa-heart-o fa-fw fa-lg"></i></a>
			{% endif %}
		</div>
	{% endif %}
{% endmacro %}

{% import _self as product_macros %}

{% extends 'base.tpl' %}

{% block content %}

	<div class="bg-img" style="background-image: url({{ product.image.full }});"></div>
	<div class="bg-mask"></div>

	<div class="content">

		<article class="product">

			<div class="row-fluid">

				<div class="span8">
					<h1>{{ product.title }}</h1>
				</div>

				<div class="span4">

					<div>
						<div class="price">
							{% if product.price_on_request == true %}
								<span class="data-product-price">Preço sob consulta</span>
								<del></del>
							{% else %}
								{% if product.promo == true %}
									<span class="data-product-price">{{ product.price_promo | money_with_sign }}</span>
									<del>{{ product.price | money_with_sign }}</del>
								{% else %}
									<span class="data-product-price">{{ product.price | money_with_sign }}</span>
									<del></del>
								{% endif %}
							{% endif %}
						</div>

						<p class="text-right"><small class="muted light data-promo-percentage">
							{% if product.price_promo_percentage == true %}
								Desconto de {{ product.price_promo_percentage }}%
							{% endif %}
						</small></p>
					</div>

				</div>

			</div>

			<hr>

			<div class="row-fluid">

				<div class="span8">
					<p class="breadcrumbs">
						<a href="{{ site_url() }}"><i class="fa fa-home"></i></a> ›
						{{ product.title }}
					</p>
				</div>

				<div class="span4">
					{% if product.reference %}
						<p class="text-right"><small class="muted light"><strong>Referência:</strong> <span class="sku">{{ product.reference }}</span></small></p>
					{% endif %}
				</div>
			</div>

			{{ form_open_cart(product.id, { 'class' : 'add-cart clearfix' }) }}

				{% if product.status == 1 %}

					<div class="form-inline">

						<div class="data-product-info">
							<input type="number" class="span1" name="qtd" value="1" {% if product.stock.stock_sold_single %} data-toggle="tooltip" data-placement="bottom" data-original-title="Só é possível comprar 1 unidade deste produto." title="Só é possível comprar 1 unidade deste produto." readonly {% endif %}>

							&nbsp; &nbsp;
						</div>

						{% if product.options %}
							<select class="span2 select-product-options" name="option">
								{% for option in product.options %}

									{% if option.active %}
										{% set option_display_price = option.promo ? option.price_promo : option.price %}

										<option value="{{ option.id }}" data-id_variant_1="{{ option.id_variant_1 }}" data-id_variant_2="{{ option.id_variant_2 }}" data-id_variant_3="{{ option.id_variant_3 }}" {% if product.stock.stock_enabled and not product.stock.stock_backorder and option.stock <= 0 and not option.price_on_request %}disabled{% endif %}>
											{{ option.title }} &ndash; {{ option.price_on_request == true ? 'Preço sob consulta' : option_display_price | money_with_sign }}
										</option>
									{% endif %}

								{% endfor %}
							</select>
						{% endif %}

						{{ product_macros.wishlist_block(product, user) }}

						<div class="data-product-info">
							<button type="submit" class="btn btn-link pull-right">Adicionar ao Carrinho</button>
						</div>

						<div class="data-product-on-request">
							<a class="btn btn-link pull-right price-on-request" href="{{ site_url('contact') }}?p={{ product.title|url_encode }}">Contactar</a>
						</div>

					</div>

				{% elseif product.status == 3 %}
					<div class="product-not-vendible">
						<h4>O produto encontra-se sem stock.</h4>

						{{ product_macros.wishlist_block(product, user) }}
					</div>
				{% elseif product.status == 4 %}
					<div class="product-not-vendible">
						<h4>O produto estará disponível brevemente.</h4>

						{{ product_macros.wishlist_block(product, user) }}
					</div>
				{% endif %}

			{{ form_close() }}

			<div class="row-fluid data-product-info">
				<div class="span6">
					{% if product.tax > 0 %}
						{% if store.taxes_included == false %}
							<p class=""><small class="muted light">Ao preço acresce IVA a {{ product.tax }}%</small></p>
						{% else %}
							<p class=""><small class="muted light">IVA incluído</small></p>
						{% endif %}
					{% endif %}
				</div>

				<div class="span6">
					{% if product.stock.stock_show %}
						<p class="text-right"><small class="muted light"><strong>Stock:</strong> <span class="data-product-stock_qty">{{ product.stock.stock_qty }}</span> unidades em stock</small></p>
					{% endif %}
				</div>
			</div>

			<div class="flexslider">
				<ul class="slides">
					<li>
						<img src="{{ product.image.full }}" alt="{{ product.title|e_attr }}">
					</li>

					{% for image in product.images %}
						<li><img src="{{ image.full }}" alt="{{ product.title|e_attr }}"></li>
					{% endfor %}

				</ul>
			</div>

			<br>

			<div class="row-fluid">

				<div class="share">
					<a target="_blank" href="http://www.facebook.com/sharer.php?u={{ product.url }}" class="text-muted"><i class="fa fa-lg fa-facebook fa-fw"></i></a> &nbsp;
					<a target="_blank" href="https://wa.me/?text={{ "#{product.title}: #{product.url}"|url_encode }}" class="text-muted"><i class="fa fa-lg fa-whatsapp fa-fw"></i></a> &nbsp;
					<a target="_blank" href="https://twitter.com/share?url={{ product.url }}&text={{ character_limiter(description, 100)|url_encode }}" class="text-muted"><i class="fa fa-lg fa-twitter fa-fw"></i></a> &nbsp;
					<a target="_blank" href="https://pinterest.com/pin/create/bookmarklet/?media={{ product.image.full }}&url={{ product.url }}&description={{ product.title|url_encode }}" class="text-muted"><i class="fa fa-lg fa-pinterest fa-fw"></i></a>
				</div>

			</div>

			{% if product.description %}
				<hr>
				<div class="product-description break-word">
					{{ product.description }}
				</div>
			{% endif %}

			{% if product.file %}
				<hr>
				<a target="_blank" href="{{ product.file }}" class="colorless book"><i class="fa fa-download"></i> Download Ficheiro Anexo</a>
			{% endif %}

			{% if product.video_embed_url %}
				<div class="video-wrapper">
					<iframe src="{{ product.video_embed_url }}" height="620"></iframe>
				</div>
			{% endif %}

			{% if apps.facebook_comments.comments_products %}
				<hr>
				<div class="boxed hidden-phone">
					<div class="fb-comments" data-href="{{ product.permalink }}" data-num-posts="3" data-colorscheme="light" data-width="100%"></div>
				</div>
			{% endif %}

		</article>

	</div>

{% endblock %}