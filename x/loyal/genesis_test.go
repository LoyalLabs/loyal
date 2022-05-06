package loyal_test

import (
	"testing"

	keepertest "github.com/LoyalLabs/loyal/testutil/keeper"
	"github.com/LoyalLabs/loyal/testutil/nullify"
	"github.com/LoyalLabs/loyal/x/loyal"
	"github.com/LoyalLabs/loyal/x/loyal/types"
	"github.com/stretchr/testify/require"
)

func TestGenesis(t *testing.T) {
	genesisState := types.GenesisState{
		Params: types.DefaultParams(),

		// this line is used by starport scaffolding # genesis/test/state
	}

	k, ctx := keepertest.LoyalKeeper(t)
	loyal.InitGenesis(ctx, *k, genesisState)
	got := loyal.ExportGenesis(ctx, *k)
	require.NotNil(t, got)

	nullify.Fill(&genesisState)
	nullify.Fill(got)

	// this line is used by starport scaffolding # genesis/test/assert
}
