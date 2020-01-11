- namespace [%fileName%]

- include './base' as placeholder

- block index->card(title, description)
	< section.card
		< h1.&__title
			{title|trim}

		< .&__description
			{description|trim}

- template index(rootTag, @params = {}) extends base.index
	- block root
		- super

		< ${rootTag}#cards.cards
			- block list
				- if @list
					- for var i = 0; i < @list.length; ++i
						: el = @list[i]
						+= self.card(el.title, el.description)

				- else
					< img.&__empty-list &
						src = https://example.com/empty.png |
						alt = Empty list
					.
					< span
						List is empty
