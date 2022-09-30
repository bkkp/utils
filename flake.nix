{
  outputs = { self }: {

    lib = {
      overlayMidgard = overlay: (final: prev: { midgard = (prev.midgard or { }) // (overlay final prev); });
    };

  };
}