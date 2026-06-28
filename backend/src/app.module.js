import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';

import { AppController } from './app.controller';
import { AuthModule } from './modules/auth/auth.module';
import { BranchesModule } from './modules/branches/branches.module';
import { ContactsModule } from './modules/contacts/contacts.module';
import { ReviewsModule } from './modules/reviews/reviews.module';
import { ServicesModule } from './modules/services/services.module';
import { TipsModule } from './modules/tips/tips.module';
import { UsersModule } from './modules/users/users.module';
import { SeedModule } from './seed/seed.module';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    TypeOrmModule.forRootAsync({
      inject: [ConfigService],
      useFactory: (configService) => {
        const dbType = configService.get('DB_TYPE', 'postgres');
        const databaseUrl = (
          configService.get('DATABASE_URL') ||
          configService.get('DB_URL') ||
          ''
        ).trim();
        const synchronize = configService.get('DB_SYNC', 'true') === 'true';
        const logging = configService.get('DB_LOGGING', 'false') === 'true';

        if (dbType === 'sqlite') {
          return {
            type: 'sqlite',
            database: configService.get('DB_DATABASE', ':memory:'),
            autoLoadEntities: true,
            synchronize,
            logging,
          };
        }

        const sslEnabled = configService.get('DB_SSL', 'false') === 'true';
        const postgresBaseConfig = {
          type: 'postgres',
          autoLoadEntities: true,
          synchronize,
          logging,
          ssl: sslEnabled ? { rejectUnauthorized: false } : false,
        };

        if (databaseUrl) {
          return {
            ...postgresBaseConfig,
            url: databaseUrl,
          };
        }

        const username = configService.get('DB_USERNAME');
        const password = configService.get('DB_PASSWORD');
        const database = configService.get('DB_DATABASE');

        if (!username || !password || !database) {
          throw new Error(
            'Postgres config is incomplete. Set DATABASE_URL from Neon, or set DB_USERNAME, DB_PASSWORD, and DB_DATABASE.',
          );
        }

        return {
          ...postgresBaseConfig,
          host: configService.get('DB_HOST', 'localhost'),
          port: Number(configService.get('DB_PORT', 5432)),
          username,
          password,
          database,
        };
      },
    }),
    UsersModule,
    AuthModule,
    ServicesModule,
    BranchesModule,
    ReviewsModule,
    TipsModule,
    ContactsModule,
    SeedModule,
  ],
  controllers: [AppController],
})
export class AppModule {}
