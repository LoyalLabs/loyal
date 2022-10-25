package keeper_test

import (
	"testing"

	testkeeper "github.com/LoyalLabs/loyal/testutil/keeper"
	"github.com/LoyalLabs/loyal/x/loyal/types"
	"github.com/stretchr/testify/require"
)

func TestGetParams(t *testing.T) {
	k, ctx := testkeeper.LoyalKeeper(t)
	params := types.DefaultParams()

	k.SetParams(ctx, params)

	require.EqualValues(t, params, k.GetParams(ctx))
}
