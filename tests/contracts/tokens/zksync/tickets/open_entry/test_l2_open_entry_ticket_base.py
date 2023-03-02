def setup_open_entry_ticket_contract(admin_facet, naffle_contract, from_admin):
    admin_facet.setL2NaffleContractAddress(naffle_contract.address, from_admin)