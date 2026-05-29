import { Test } from '@nestjs/testing';
import { AppController } from './app.controller';

describe('AppController', () => {
  let appController;

  beforeEach(async () => {
    const app = await Test.createTestingModule({
      controllers: [AppController],
    }).compile();

    appController = app.get(AppController);
  });

  describe('getHealth', () => {
    it('should return health status ok', () => {
      const response = appController.getHealth();
      expect(response.status).toBe('ok');
      expect(response.name).toBe('SafeReach API');
      expect(response.timestamp).toBeDefined();
    });
  });
});
