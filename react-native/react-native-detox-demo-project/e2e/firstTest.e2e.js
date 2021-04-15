describe('Example', () => {
  beforeEach(async () => {
    await device.reloadReactNative();
  });

  it('should have edit text on welcome screen', async () => {
    await expect(element(by.id('edit-text'))).toBeVisible();
  });

});
