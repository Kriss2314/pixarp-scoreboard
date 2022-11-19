var visable = false;

$(function () {
	window.addEventListener('message', function (event) {

		if (event.data.action == "updatePraca"){
			$('#praca').html(event.data.praca);
		};

		if(event.data.update === true){
		
		}

		switch (event.data.action) {
			case 'toggle':
				if (visable) {
					$('#wrap').fadeOut(500);
				} else {
					$('#wrap').fadeIn(500);
				}

				visable = !visable;
				break;

			case 'close':
				$('#wrap').fadeOut(150);
				visable = false;
				break;
			case 'open':

				$('#wrap').fadeIn(150);
			visable = true;
					break;
			case 'toggleID':

				if (event.data.state) {
					$('td:nth-child(2),th:nth-child(2)').show();
					$('td:nth-child(5),th:nth-child(5)').show();
				} else {
					$('td:nth-child(2),th:nth-child(2)').hide();
					$('td:nth-child(5),th:nth-child(5)').hide();
				}

				break;

			case 'updatePlayerJobs':
				var jobs = event.data.jobs;

				$('#player_count').html(jobs.player_count);

				$('#ems').html(jobs.ems);
				$('#police').html(jobs.police);
				$('#mechanic').html(jobs.mechanic);
				$('#fire').html(jobs.fire);
				$('#dmv').html(jobs.dmv);
				$('#estate').html(jobs.estate);
				$('#safj').html(jobs.cardealer);
				break;

			case 'updatePlayerList':
				$('#playerlist tr:gt(0)').remove();
				$('#playerlist').append(event.data.players);
				break;

			case 'updatePing':
				updatePing(event.data.players);
				break;

			case 'updateServerInfo':
				if (event.data.maxPlayers) {
					$('#max_players').html(event.data.maxPlayers);
				}

				if (event.data.uptime) {
					$('#server_uptime').html(event.data.uptime);
				}

				break;

			case 'updatePlayerList':
					$('#playerwrapper').empty();
					$('#playerwrapper').append(event.data.players);
					applyPingColor();
					sortPlayerList();
			break;

			case 'updateStatus':
				var info = event.data.infos
			
				
			break;

			case 'updateGtaStat':
				if(event.data.name === 'health'){
					$('#tekstHealth').html(`Zdrowie ${event.data.stat}%`)
					$('.progress-health').css('width', Math.round(event.data.stat) + '%');
				} else if(event.data.name == 'sprint'){
					if(event.data.stat < 100){
						$('#sprint').show();
						$('#tekstSprint').html(`Energia ${event.data.stat}%`)
					} else {
						$('#sprint').hide();
					}
				} else if(event.data.name == 'hunger') {
				
						$('#tekstHunger').html(`Jedzenie ${Math.round(event.data.stat)}%`)
						$('.progress-hunger').css('width', Math.round(event.data.stat) + '%');
					
					} else if(event.data.name == 'thirst') {
					if(event.data.stat > 0){
						$('#tekstThirst').html(`Nawodnienie ${Math.round(event.data.stat)}%`);
						$('.progress-thirst').css('width', Math.round(event.data.stat) + '%');
				
					} 
				} else if(event.data.name == 'stress') {
			
						$('#tekstDrunk').html(`Zmęczenie ${Math.round(event.data.stat)}%`);
						$('.progress-drunk').css('width', Math.round(event.data.stat) + '%');

				}
				 else if(event.data.name == 'alcohol') {
			
						$('#tekstAlcohol').html(`Używki ${Math.round(event.data.stat)}%`);
						$('.progress-alcohol').css('width', Math.round(event.data.stat) + '%');

				}
				break;
				

			case 'updateSila':
				if(event.data.value < 100){
					$('#sila').show();
					$('#tekstSila').html(`Siła ${event.data.value}%`)
				} else {
					$('#sila').hide();
				}
				break;
			
			default:
				break;
		}
	}, false);
});

// Todo: not the best code
function updatePing(players) {
	jQuery.each(players, function (index, element) {
		if (element != null) {
			$('#playerlist tr:not(.heading)').each(function () {
				$(this).find('td:nth-child(2):contains(' + element.id + ')').each(function () {
					$(this).parent().find('td').eq(2).html(element.ping);
				});

				$(this).find('td:nth-child(5):contains(' + element.id + ')').each(function () {
					$(this).parent().find('td').eq(5).html(element.ping);
				});
			});
		}
	});
}