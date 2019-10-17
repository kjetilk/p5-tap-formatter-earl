use Test::Perl::Critic(-exclude => [
												'RequireFinalReturn',
											   'ProhibitUnusedPrivateSubroutines',
												'ProhibitTwoArgOpen',
											  ],
							  -severity => 3);
all_critic_ok();
