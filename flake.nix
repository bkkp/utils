{
  outputs = { self }: {

    lib = {
      midgardOverlay = overlay: (final: prev: { midgard = (prev.midgard or { }) // (overlay final prev); });
    };

  };
}