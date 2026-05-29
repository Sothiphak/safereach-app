import { Controller, Get } from '@nestjs/common';

@Controller()
export class AppController {
  @Get()
  getHealth() {
    return {
      status: 'ok',
      name: 'SafeReach API',
      timestamp: new Date().toISOString(),
    };
  }
}
